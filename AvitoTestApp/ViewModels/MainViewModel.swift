//
//  MainViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation
import Combine

@MainActor final class MainViewModel: ObservableObject {
    
    // MARK: - Combine Published values
    @Published var cellViewModels: [CellViewModel] = []
    @Published var screenState: ScreenState = .downloading
    
    private var advertisements: [Advertisement] = []
    
    // MARK: - Dependencies
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
        self.fetchAdvertisements()
    }
    
    private func fetchAdvertisements() {
        Task {
            do {
                print("start fetching ads")
                screenState = .downloading
                advertisements = try await networkManager.getAdvertisements()
                cellViewModels = advertisements.map { CellViewModel(ad: $0) }
//                try await Task.sleep(for: .seconds(3))
                screenState = .content
                print("finish fetching ads")
            } catch NetworkError.noInternetConnection {
                screenState = .error(message: "Нет подключения к интернету")
            } catch NetworkError.timeout {
                screenState = .error(message: "Timeout")
            } catch {
                screenState = .error(message: "Ошибка")
            }
        }
    }
}
