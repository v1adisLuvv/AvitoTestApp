//
//  MainViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    
    @Published var cellViewModels: [CellViewModel] = []
    @Published var screenState: ScreenState = .downloading
    
    private var advertisements: [Advertisement] = []
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
                cellViewModels = advertisements.map { CellViewModel(ad: $0) }
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
