//
//  ImageCache.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import Foundation

final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, AnyObject>()
    
    func image(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as? Data
    }
    
    func save(_ image: Data, forKey key: String) {
        cache.setObject(image as AnyObject, forKey: key as NSString)
    }
}
