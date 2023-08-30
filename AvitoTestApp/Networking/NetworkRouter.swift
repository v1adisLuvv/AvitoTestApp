//
//  NetworkRouter.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

protocol NetworkRouter {
    func request(_ route: some EndpointType) async throws -> (Data, URLResponse)
    func loadImage(from url: String) async throws -> (Data, URLResponse)
}

final class DefaultNetworkRouter: NetworkRouter {
    
    func request(_ route: some EndpointType) async throws -> (Data, URLResponse) {
        let request = buildRequest(from: route)
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }
    
    func loadImage(from url: String) async throws -> (Data, URLResponse) {
        let request = try buildRequest(from: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }
    
    private func buildRequest(from route: some EndpointType) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appending(path: route.path), timeoutInterval: route.timeoutInterval)
        request.httpMethod = route.httpMethod.rawValue
        return request
    }
    
    private func buildRequest(from url: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw NetworkError.badImageURL
        }
        let request = URLRequest(url: url, timeoutInterval: 20)
        return request
    }
}


