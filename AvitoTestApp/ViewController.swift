//
//  ViewController.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-27.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Layout
    private struct Layout {
        static let collectionViewTopOffset: CGFloat = 10
        static let collectionViewLeadingOffset: CGFloat = 15
        static let collectionViewBottomOffset: CGFloat = -10
        static let collectionViewTrailingOffset: CGFloat = -15
        
        static let collectionViewCellSpacing: CGFloat = 10
        static let collectionViewNumberOfColumns: Int = 2
        
    }
    
    private var collectionViewCellSize: CGSize {
        let totalSpacing = (CGFloat(Layout.collectionViewNumberOfColumns) - 1) * Layout.collectionViewCellSpacing
        let availableWidth = collectionView.bounds.width - Layout.collectionViewLeadingOffset - Layout.collectionViewTrailingOffset - totalSpacing
        let cellWidth = availableWidth / CGFloat(Layout.collectionViewNumberOfColumns)
        return CGSize(width: cellWidth, height: cellWidth)
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
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.collectionViewTopOffset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.collectionViewLeadingOffset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Layout.collectionViewBottomOffset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Layout.collectionViewTrailingOffset),
        ])
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .green
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
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
