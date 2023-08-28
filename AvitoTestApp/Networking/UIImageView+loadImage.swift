//
//  UIImageView+loadImage.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-28.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String) {
        guard let url = URL(string: url) else {
            print("badImageURL")
            return
        }
        
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            print("load image from cache \(url.absoluteString)")
            self.image = cachedImage
        } else {
            DispatchQueue.global().async { [weak self] in
                print("start downloading image \(url.absoluteString)")
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    ImageCache.shared.save(image, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
}
