//
//  DetailViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var advertisement: Advertisement?
    @Published var screenState: ScreenState = .downloading
    
    private let id: Int
    private let networkManager: NetworkManager
    
    init(id: Int, networkManager: NetworkManager = DefaultNetworkManager()) {
        self.id = id
        self.networkManager = networkManager
    }
    
    func fetchAdvertisement() {
        Task {
            do {
                print("start fetching detail ad")
                screenState = .downloading
                advertisement = try await networkManager.getDetailAdvertisement(id: id)
//                try await Task.sleep(for: .seconds(3))
                screenState = .content
                print("finish fetching detail ad")
            } catch {
                screenState = .error(message: "Failed loading data")
                print("bad detail ad")
            }
        }
    }
}
