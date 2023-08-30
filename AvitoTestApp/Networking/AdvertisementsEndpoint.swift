//
//  AdvertisementsEndpoint.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

enum AdvertisementsEndpoint {
    case main
    case detail(id: Int)
}

extension AdvertisementsEndpoint: EndpointType {
    var baseURL: URL {
        let urlString = "https://www.avito.st/s/interns-ios/"
        guard let url = URL(string: urlString) else { fatalError("base URL is invalid") }
        return url
    }
    
    var path: String {
        switch self {
        case .main:
            return "main-page.json"
        case .detail(let id):
            return "details/\(id).json"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var timeoutInterval: TimeInterval {
        return 10
    }
}
