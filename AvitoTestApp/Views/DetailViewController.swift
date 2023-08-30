//
//  DetailViewController.swift
//  AvitoTestApp
//
//  Created by Vlad Boguzh on 2023-08-29.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    // MARK: - Variables
    private let id: Int
    private let viewModel: DetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Layout
    private struct Layout {
        static let descriptionViewInset: CGFloat = 10
        static let titleToLocationLabelOffset: CGFloat = 30
        static let addressToDescriptionTitleOffset: CGFloat = 20
        static let descriptionTitleToDescriptionLabelOffset: CGFloat = 10
        static let descriptionLabelToAboutSellerLabelOffset: CGFloat = 20
        static let aboutSellerToEmailLabelOffset: CGFloat = 10
        static let emailToPhoneLabelOffset: CGFloat = 5
        static let phoneToCreatedDateOffset: CGFloat = 10
    }
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = { // content view for scroll view
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "49 999 ₽"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ремонт Электроплит Варочных панелей Духовых печей"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "р-н Октябрьский"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Владимирская область, Владимир, 1-я Никольская ул., 6"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aboutSellerLabel: UILabel = {
        let label = UILabel()
        label.text = "О продавце"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "example@gmail.com"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+7 (123)-456-78-90"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createdDateLabel: UILabel = {
        let label = UILabel()
        label.text = "15 July"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // all views except image will be places inside this view
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    init(id: Int) {
        self.id = id
        self.viewModel = DetailViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel.$advertisement
            .combineLatest(viewModel.$screenState)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] advertisement, screenState in
                guard let self = self else { return }
                self.handleScreenState(advertisement, screenState)
            }
            .store(in: &cancellables)
        
        viewModel.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    self.imageView.image = image
                }
            }
            .store(in: &cancellables)
        
        setupConstraints()
    }
    
    private func handleScreenState(_ advertisement: Advertisement?, _ screenState: ScreenState) {
        switch screenState {
        case .downloading:
            loadingIndicator.startAnimating()
            contentView.isHidden = true
            errorLabel.isHidden = true
        case .error(let message):
            loadingIndicator.stopAnimating()
            errorLabel.text = message
            contentView.isHidden = true
            errorLabel.isHidden = false
        case .content:
            guard let advertisement = advertisement else {
                viewModel.screenState = .error(message: "Empty advertisement")
                return
            }
            loadingIndicator.stopAnimating()
            errorLabel.isHidden = true
            contentView.isHidden = false
            setupContent(with: advertisement)
        }
    }
    
    // MARK: - Configuring the screen
    private func setupContent(with ad: Advertisement) {
        priceLabel.text = ad.price
        titleLabel.text = ad.title
        locationLabel.text = ad.location
        addressLabel.text = ad.address
        descriptionLabel.text = ad.description
        emailLabel.text = ad.email
        phoneLabel.text = ad.phoneNumber
        createdDateLabel.text = "Опубликовано " + handleDate(ad.createdDate)
    }
    
    private func handleDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: dateString) else {
            return "неизвестно"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM, yyyy"
        return outputFormatter.string(from: date)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        scrollView.addSubview(contentView)
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
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
        
        
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        contentView.addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                               constant: Layout.descriptionViewInset),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Layout.descriptionViewInset),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Layout.descriptionViewInset),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Layout.descriptionViewInset)
        ])
        
        descriptionView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: Layout.titleToLocationLabelOffset),
            locationLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(descriptionTitle)
        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: addressLabel.bottomAnchor,
                                                  constant: Layout.addressToDescriptionTitleOffset),
            descriptionTitle.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            descriptionTitle.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor,
                                                  constant: Layout.descriptionTitleToDescriptionLabelOffset),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
        ])
        
        descriptionView.addSubview(aboutSellerLabel)
        NSLayoutConstraint.activate([
            aboutSellerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,
                                                  constant: Layout.descriptionLabelToAboutSellerLabelOffset),
            aboutSellerLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            aboutSellerLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor)
        ])
        
        descriptionView.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: aboutSellerLabel.bottomAnchor,
                                            constant: Layout.aboutSellerToEmailLabelOffset),
            emailLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
        ])
        
        descriptionView.addSubview(phoneLabel)
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,
                                            constant: Layout.emailToPhoneLabelOffset),
            phoneLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
        ])
        
        descriptionView.addSubview(createdDateLabel)
        NSLayoutConstraint.activate([
            createdDateLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor,
                                                  constant: Layout.phoneToCreatedDateOffset),
            createdDateLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            createdDateLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            createdDateLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor)
        ])
    }
}
