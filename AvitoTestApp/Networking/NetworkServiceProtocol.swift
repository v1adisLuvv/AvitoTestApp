//
//  NetworkServiceProtocol.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchAdvertisements() async throws -> [Advertisement]
    func fetchDetailAdveritisement(id: String) async throws -> Advertisement
}
