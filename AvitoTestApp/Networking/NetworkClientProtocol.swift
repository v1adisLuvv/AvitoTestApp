//
//  NetworkClientProtocol.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

protocol NetworkClientProtocol {
    func performRequest(url: String) async throws -> Data
    func fetchCodableData<T: Codable>(url: String) async throws -> T
}
