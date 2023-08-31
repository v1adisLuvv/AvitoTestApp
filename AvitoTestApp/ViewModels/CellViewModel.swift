//
//  CellViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-31.
//

import Foundation
import Combine

@MainActor final class CellViewModel: ObservableObject {
    
    // MARK: - Combine Published values
    @Published var imageData: Data?
    
    let ad: Advertisement
    
    // MARK: - Dependencies
    private let networkManager: NetworkManager
    
    init(ad: Advertisement, networkManager: NetworkManager = DefaultNetworkManager()) {
        self.ad = ad
        self.networkManager = networkManager
        self.loadImage(from: ad.imageURL)
    }
    
    private func loadImage(from url: String) {
        Task {
            do {
                imageData = try await networkManager.getImage(from: url)
            } catch NetworkError.timeout {
                print("timeout")
            } catch NetworkError.noInternetConnection {
                print("no connection")
            } catch {
                print("another error")
            }
        }
    }
}
