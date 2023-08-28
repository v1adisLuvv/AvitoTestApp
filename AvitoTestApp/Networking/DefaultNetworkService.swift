//
//  DefaultNetworkService.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

final class DefaultNetworkService: NetworkServiceProtocol {
    
    let networkClient = DefaultNetworkClient()
    let baseURL = "https://www.avito.st/s/interns-ios"
    
    func fetchAdvertisements() async throws -> [Advertisement] {
        let url = baseURL + "/main-page.json"
        let ads: Advertisements = try await networkClient.fetchCodableData(url: url)
        return ads.advertisements
    }
    
    func fetchDetailAdveritisement(id: String) async throws -> Advertisement {
        let url = baseURL + "/\(id).json"
        return try await networkClient.fetchCodableData(url: url)
    }
}
