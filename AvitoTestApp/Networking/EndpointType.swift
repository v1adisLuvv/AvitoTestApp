//
//  EndpointType.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-30.
//

import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
}
