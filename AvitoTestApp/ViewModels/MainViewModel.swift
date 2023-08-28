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
    
    private let networkService = DefaultNetworkService()
    
    func fetchAdvertisements() {
        Task {
            do {
                print("start fetching ads")
                screenState = .downloading
                advertisements = try await networkService.fetchAdvertisements()
                sleep(1)
                screenState = .content
                print("finish fetching ads")
            } catch {
                screenState = .error(message: "Failed loading data")
                print("bad ads")
            }
        }
    }
}
