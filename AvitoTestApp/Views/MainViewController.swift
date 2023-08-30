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
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Error"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel.$advertisements
            .combineLatest(viewModel.$screenState)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, screenState in
                guard let self = self else { return }
                self.handleScreenState(screenState)
            }
            .store(in: &cancellables)
        
        viewModel.fetchAdvertisements()
        
        setupConstraints()
    }
    
    private func handleScreenState(_ screenState: ScreenState) {
        switch screenState {
        case .downloading:
            loadingIndicator.startAnimating()
            collectionView.isHidden = true
            errorLabel.isHidden = true
        case .error(let message):
            loadingIndicator.stopAnimating()
            errorLabel.text = message
            collectionView.isHidden = true
            errorLabel.isHidden = false
        case .content:
            loadingIndicator.stopAnimating()
            errorLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.collectionViewVerticalInset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.collectionViewVerticalInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.collectionViewHorizontalInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.collectionViewHorizontalInset),
        ])
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: - MainViewController + UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Cannot cast cell")
        }
        let ad = viewModel.advertisements[indexPath.item]
        cell.configure(with: ad)
        if cell.currentID == ad.id {
            cell.loadImage(from: ad.imageURL, id: ad.id)
        }
        return cell
    }
}

// MARK: - MainViewController + UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController(id: indexPath.item + 1)
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
