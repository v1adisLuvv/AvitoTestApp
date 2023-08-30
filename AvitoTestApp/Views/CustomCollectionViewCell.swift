//
//  CustomCollectionViewCell.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-27.
//

import UIKit
import Combine

final class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "cell"
    var currentID: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title placeholder"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "49 999 ₽"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Moscow, Req Square"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.text = "15 July"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationAndDateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(locationLabel)
        stack.addArrangedSubview(createdDateLabel)
        
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(locationAndDateStackView)
        
        return stack
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .systemBackground
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        priceLabel.text = ""
        locationLabel.text = ""
        createdDateLabel.text = ""
        imageView.image = nil
        currentID = nil
    }
    
    // MARK: - Configuring the cell
    func configure(with viewModel: CellViewModel) {
        currentID = viewModel.ad.id
        titleLabel.text = viewModel.ad.title
        priceLabel.text = viewModel.ad.price
        locationLabel.text = viewModel.ad.location
        createdDateLabel.text = viewModel.ad.createdDate
        
        viewModel.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    self.imageView.image = image
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
