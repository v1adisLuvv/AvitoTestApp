//
//  MainViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    @Published var advertisements: [Advertisement] = []
    @Published var screenState: ScreenState = .downloading
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchAdvertisements() {
        Task {
            do {
                print("start fetching ads")
                screenState = .downloading
                advertisements = try await networkManager.getAdvertisements()
//                try await Task.sleep(for: .seconds(3))
                screenState = .content
                print("finish fetching ads")
            } catch {
                screenState = .error(message: "Failed loading data")
                print("bad ads")
            }
        }
    }
}
