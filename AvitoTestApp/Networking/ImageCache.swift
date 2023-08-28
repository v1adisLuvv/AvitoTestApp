//
//  ImageCache.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
