//
//  DetailViewModel.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var advertisement: Advertisement = Advertisement(id: "1", title: "", price: "", location: "", imageURL: "", createdDate: "", description: "", email: "", phoneNumber: "", address: "")
    @Published var screenState: ScreenState = .downloading
    private var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    private let networkService = DefaultNetworkService()
    
    func fetchAdvertisement() {
        Task {
            do {
                print("start fetching detail ad")
                screenState = .downloading
                advertisement = try await networkService.fetchDetailAdveritisement(id: id)
//                try await Task.sleep(for: .seconds(3))
                // create detail screen, flashing previews in a downloading state
                // review the network layer
                screenState = .content
                print("finish fetching detail ad")
            } catch NetworkClientError.invalidResponseCode {
                screenState = .error(message: "Failed loading data")
                print("bad detail ad")
            }
        }
    }
}
