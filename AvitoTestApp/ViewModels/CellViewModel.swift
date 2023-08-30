//
//  CellViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-31.
//

import Foundation
import Combine

final class CellViewModel: ObservableObject {
    
    @Published var imageData: Data?
    
    let ad: Advertisement
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
            } catch {
                print(error)
                print("bad cell image")
            }
        }
    }
}
