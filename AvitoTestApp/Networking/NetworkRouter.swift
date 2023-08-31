//
//  NetworkRouter.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

protocol NetworkRouter {
    func request<Endpoint: EndpointType>(_ route: Endpoint) async throws -> Data
    func loadImage(from url: String) async throws -> Data
}

final class DefaultNetworkRouter: NetworkRouter {
    
    private let imageTimeoutInterval: TimeInterval = 15
    
    // MARK: - NetworkRouter methods
    func request<Endpoint: EndpointType>(_ route: Endpoint) async throws -> Data {
        do {
            let request = buildRequest(from: route)
            let (data, response) = try await URLSession.shared.data(for: request)
            if let responseError = handleResponse(response) {
                throw responseError
            }
            return data
        } catch {
            throw handleError(error)
        }
    }
    
    func loadImage(from url: String) async throws -> Data {
        do {
            let request = try buildRequest(from: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            if let responseError = handleResponse(response) {
                throw responseError
            }
            return data
        } catch {
            throw handleError(error)
        }
    }
    
    // MARK: - Build Request private methods
    private func buildRequest<Endpoint: EndpointType>(from route: Endpoint) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appending(path: route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: route.timeoutInterval)
        request.httpMethod = route.httpMethod.rawValue
        return request
    }
    
    private func buildRequest(from url: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw NetworkError.badImageURL
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: imageTimeoutInterval)
        return request
    }
    
    // MARK: - Handling response private methods
    private func handleResponse(_ response: URLResponse) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return NetworkError.unexpectedResponseType
        }
        guard (200..<300).contains(response.statusCode) else {
            return NetworkError.badStatusCode
        }
        return nil
    }
    
    private func handleError(_ error: Error) -> NetworkError {
        switch (error as? URLError)?.code {
        case .some(.notConnectedToInternet):
            return NetworkError.noInternetConnection
        case .some(.timedOut):
            return NetworkError.timeout
        default:
            return error as? NetworkError ?? NetworkError.networkError
        }
    }
}



