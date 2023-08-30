//
//  DefaultNetworkClient.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

enum NetworkClientError: Error {
    case invalidURL
    case invalidResponseType
    case invalidResponseCode
    case failedToDecodeData
}

final class DefaultNetworkClient: NetworkClientProtocol {
    
    func performRequest(url: String) async throws -> Data {
        let request = try configureURLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkClientError.invalidResponseType
        }
        guard (200..<300).contains(response.statusCode) else {
            print(response)
            throw NetworkClientError.invalidResponseCode
        }
        return data
    }
    
    func fetchCodableData<T: Codable>(url: String) async throws -> T {
        let data = try await performRequest(url: url)
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkClientError.failedToDecodeData
        }
    }
    
    private func configureURLRequest(url: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw NetworkClientError.invalidURL
        }
        return URLRequest(url: url)
    }
}
