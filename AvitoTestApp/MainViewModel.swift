//
//  MainViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Data
    @Published var advertisements: [Advertisement] = []
    private let networkService = DefaultNetworkService()
    
    func fetchAdvertisements() {
        Task {
            do {
                print("start fetching ads")
                advertisements = try await networkService.fetchAdvertisements()
                print("finish fetching ads")
            } catch {
                print("bad ads")
            }
        }
    }
}
