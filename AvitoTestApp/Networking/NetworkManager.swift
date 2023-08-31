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
    
    // MARK: - Dependencies
    let router: NetworkRouter
    
    init(router: NetworkRouter = DefaultNetworkRouter()) {
        self.router = router
    }
    
    // MARK: - NetworkManager methods
    func getAdvertisements() async throws -> [Advertisement] {
        let data: Advertisements = try await getDecodableData(from: AdvertisementsEndpoint.main)
        return data.advertisements
    }
    
    func getDetailAdvertisement(id: Int) async throws -> Advertisement {
        let data: Advertisement = try await getDecodableData(from: AdvertisementsEndpoint.detail(id: id))
        return data
    }
    
    func getImage(from url: String) async throws -> Data {
        if let imageData = ImageCache.shared.image(forKey: url) {
            return imageData
        }
        let data = try await router.loadImage(from: url)
        ImageCache.shared.save(data, forKey: url)
        return data
    }
    
    // MARK: - Getting and handling JSON Decodable data private methods
    private func getDecodableData<T: Decodable, Endpoint: EndpointType>(from route: Endpoint) async throws -> T {
        let data = try await router.request(route)
        if let decodedData: T = decodeResponse(data) {
            return decodedData
        } else {
            throw NetworkError.unableToDecode
        }
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data) -> T? {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
}
