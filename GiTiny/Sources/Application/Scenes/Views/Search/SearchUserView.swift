//
//  SearchUserView.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchUserView: UIView {
    
    // MARK: - NSLayoutConstraints
    
    private var emailImageViewLeadingToView: NSLayoutConstraint?
    private var emailImageViewLeadingToLocation: NSLayoutConstraint?
    
    // MARK: - Properties
    
    private var viewModel: SearchUserViewModel!
    
    // MARK: - UI Components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "location")
        imageView.isHidden = true
        return imageView
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    private let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "email")
        imageView.isHidden = true
        return imageView
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(locationImageView)
        addSubview(locationLabel)
        addSubview(emailImageView)
        addSubview(emailLabel)
        addSubview(lineView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func configure(with model: SearchUser, isHiddenLineView: Bool? = nil, disposeBag: DisposeBag) {
        bindViewModel(username: model.login, disposeBag: disposeBag)
        
        if let url = URL(string: model.avatar_url) {
            avatarImageView.kf.setImage(with: url)
        }
        usernameLabel.text = model.login
        
        let theme = AppAppearance.shared.theme.value
        fh.enable(normalColor: theme.fluidNormalColor1, highlightedColor: theme.fluidHighlightColor)
        usernameLabel.textColor = theme.systemDefaultTextColor
        locationImageView.changePngColorTo(color: theme.imageTintColor)
        emailImageView.changePngColorTo(color: theme.imageTintColor)
        lineView.backgroundColor = theme.lineColor
        
        if let isHidden = isHiddenLineView {
            lineView.isHidden = isHidden
        }
    }
    
    func reset() {
        avatarImageView.image = nil
        usernameLabel.text = nil
        nameLabel.text = nil
        bioLabel.text = nil
        locationLabel.text = nil
        emailLabel.text = nil
        
        locationImageView.isHidden = true
        emailImageView.isHidden = true
        
        emailImageViewLeadingToLocation?.isActive = true
        emailImageViewLeadingToView?.isActive = false
    }
    
    // MARK: - Binding
    
    private func bindViewModel(username: String, disposeBag: DisposeBag) {
        viewModel = .init(useCase: .init())
        
        // Input
        let usernameStream: Driver<String> = BehaviorRelay<String>(value: username).asDriver()
        let input = type(of: viewModel).Input(username: usernameStream)
        
        // Output
        let output = viewModel.transform(input: input)
        output.user
            .drive(onNext: { [weak self] (user) in
                guard let self = self else {return}
                
                self.nameLabel.text = user.name
                self.bioLabel.text = user.bio
                self.locationLabel.text = user.location
                self.emailLabel.text = user.email
                
                self.locationImageView.isHidden = user.location == nil
                self.emailImageView.isHidden = user.email == nil
                
                self.emailImageViewLeadingToView?.isActive = user.location == nil
                self.emailImageViewLeadingToLocation?.isActive = user.location != nil
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension SearchUserView {
    
    private func layout() {
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        usernameLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        usernameLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        nameLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        bioLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        bioLabel.setContentHuggingPriority(.init(1000), for: .vertical)
        
        locationImageView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        locationImageView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 8).isActive = true
        locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor).isActive = true
        locationLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        locationLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        emailImageView.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor).isActive = true
        emailImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        emailImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        emailImageViewLeadingToView = emailImageView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        emailImageViewLeadingToLocation = emailImageView.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 16)
        emailImageViewLeadingToLocation?.isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo: emailImageView.trailingAnchor, constant: 8).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        emailLabel.centerYAnchor.constraint(equalTo: emailImageView.centerYAnchor).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 16).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
