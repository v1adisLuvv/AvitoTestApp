//
//  NetworkManager.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

protocol NetworkManager {
    var router: NetworkRouter { get }
    func getAdvertisements() async throws -> [Advertisement]
    func getDetailAdvertisement(id: Int) async throws -> Advertisement
    func getImage(from url: String) async throws -> Data
}

final class DefaultNetworkManager: NetworkManager {
    
    let router: NetworkRouter
    
    init(router: NetworkRouter = DefaultNetworkRouter()) {
        self.router = router
    }
    
    func getAdvertisements() async throws -> [Advertisement] {
        let (data, response) = try await router.request(AdvertisementsApiEndpoint.main)
        if let error = handleResponse(response) {
            throw error
        }
        if let ads: Advertisements = decodeResponse(data) {
            return ads.advertisements
        } else {
            throw NetworkError.unableToDecode
        }
    }
    
    func getDetailAdvertisement(id: Int) async throws -> Advertisement {
        let (data, response) = try await router.request(AdvertisementsApiEndpoint.detail(id: id))
        if let error = handleResponse(response) {
            throw error
        }
        if let ad: Advertisement = decodeResponse(data) {
            return ad
        } else {
            throw NetworkError.unableToDecode
        }
    }
    
    func getImage(from url: String) async throws -> Data {
        if let imageData = ImageCache.shared.image(forKey: url) {
            return imageData
        }
        let (data, response) = try await router.loadImage(from: url)
        if let error = handleResponse(response) {
            throw error
        }
        ImageCache.shared.save(data, forKey: url)
        return data
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    private func handleResponse(_ response: URLResponse) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return .unexpectedResponseType
        }
        guard (200..<300).contains(response.statusCode) else {
            return .badStatusCode
        }
        return nil
    }
}
