//
//  NetworkError.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

enum NetworkError: Error {
    case unexpectedResponseType
    case badStatusCode
    case unableToDecode
    case badImageURL
    case noInternetConnection
    case timeout
    case networkError
}
