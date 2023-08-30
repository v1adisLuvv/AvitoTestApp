//
//  DetailViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation
import Combine

@MainActor final class DetailViewModel: ObservableObject {
    
    // MARK: - Combine Published values
    @Published var advertisement: Advertisement?
    @Published var imageData: Data?
    @Published var screenState: ScreenState = .downloading
    
    private let id: Int
    
    // MARK: - Dependencies
    private let networkManager: NetworkManager
    
    init(id: Int, networkManager: NetworkManager = DefaultNetworkManager()) {
        self.id = id
        self.networkManager = networkManager
        self.fetchAdvertisement()
    }
    
    private func fetchAdvertisement() {
        Task {
            do {
                print("start fetching detail ad")
                screenState = .downloading
                advertisement = try await networkManager.getDetailAdvertisement(id: id)
//                try await Task.sleep(for: .seconds(3))
                guard let advertisement = advertisement else {
                    screenState = .error(message: "Empty advertisement")
                    return
                }
                loadImage(from: advertisement.imageURL)
                screenState = .content
                print("finish fetching detail ad")
            } catch {
                screenState = .error(message: "Failed loading data")
                print("bad detail ad")
            }
        }
    }
    
    private func loadImage(from url: String) {
        Task {
            do {
                imageData = try await networkManager.getImage(from: url)
            } catch {
                print(error)
                print("bad detail image")
            }
        }
    }
}
