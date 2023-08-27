//
//  Advertisements.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-27.
//

import Foundation

// MARK: - Advertisements
struct Advertisements: Codable {
    let advertisements: [Advertisement]
}

// MARK: - Advertisement
struct Advertisement: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageURL: String
    let createdDate: String
    let description: String?
    let email: String?
    let phoneNumber: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
        case description, email
        case phoneNumber = "phone_number"
        case address
    }
}
