//
//  ScreenState.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

enum ScreenState {
    case error(message: String)
    case downloading
    case content
}
