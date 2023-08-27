//
//  CustomCollectionViewCell.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-27.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "cell"
    
    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Title placeholder"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.text = "49 999 ₽"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var location: UILabel = {
        let label = UILabel()
        label.text = "Moscow, Req Square"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdDate: UILabel = {
        let label = UILabel()
        label.text = "15 July"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
