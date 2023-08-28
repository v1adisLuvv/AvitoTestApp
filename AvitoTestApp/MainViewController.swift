//
//  MainViewController.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-27.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - Variables
    private var viewModel = MainViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Layout
    private struct Layout {
        static let collectionViewVerticalInset: CGFloat = 10
        static let collectionViewHorizontalInset: CGFloat = 15
        
        static let collectionViewCellSpacing: CGFloat = 10
        static let collectionViewNumberOfColumns: Int = 2
        static let collectionViewDescriptionHeight: CGFloat = 100
        
    }
    
    private var collectionViewCellImageSize: CGSize {
        let totalSpacing = (CGFloat(Layout.collectionViewNumberOfColumns) - 1) * Layout.collectionViewCellSpacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / CGFloat(Layout.collectionViewNumberOfColumns)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    private var collectionViewCellSize: CGSize {
        let cellWidth = collectionViewCellImageSize.width
        let imageHeight = collectionViewCellImageSize.height
        let cellHeight = imageHeight + Layout.collectionViewDescriptionHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel.$advertisements
            .receive(on: DispatchQueue.main)
            .sink { [weak self] advertisements in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.fetchAdvertisements()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.collectionViewVerticalInset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.collectionViewVerticalInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.collectionViewHorizontalInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.collectionViewHorizontalInset),
        ])
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        let ad = viewModel.advertisements[indexPath.item]
        cell.configure(with: ad)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.collectionViewCellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.collectionViewCellSpacing
    }
}
