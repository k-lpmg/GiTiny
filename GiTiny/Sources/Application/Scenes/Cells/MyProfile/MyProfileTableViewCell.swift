//
//  MyProfileTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya

final class MyProfileTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Components
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private let blogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let blogLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(bioLabel)
        contentView.addSubview(companyImageView)
        contentView.addSubview(companyLabel)
        contentView.addSubview(locationImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(blogImageView)
        contentView.addSubview(blogLabel)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseTableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reset()
    }
    
    // MARK: - Internal methods
    
    func configure(user: User?) {
        updateTheme()
        
        guard let user = user else {
            reset()
            return
        }
        
        if let avaterUrl = user.avatar_url, let url = URL(string: avaterUrl) {
            avatarImageView.kf.setImage(with: url)
        }
        nameLabel.text = user.name
        usernameLabel.text = user.login
        bioLabel.text = user.bio
        companyLabel.text = user.company
        locationLabel.text = user.location
        blogLabel.text = user.blog
    }
    
    // MARK: - Private methods
    
    private func reset() {
        avatarImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        bioLabel.text = nil
        companyImageView.image = nil
        companyLabel.text = nil
        locationImageView.image = nil
        locationLabel.text = nil
        blogImageView.image = nil
        blogLabel.text = nil
    }
    
    private func updateTheme() {
        let theme = AppAppearance.shared.theme.value
        
        fh.enable(normalColor: theme.fluidNormalColor2, highlightedColor: theme.fluidHighlightColor)
        
        let textColor = theme.textColor
        nameLabel.textColor = textColor
        bioLabel.textColor = textColor
        companyLabel.textColor = textColor
        locationLabel.textColor = textColor
        blogLabel.textColor = textColor
        
        companyImageView.image = UIImage(named: "company")?.withRenderingMode(.alwaysTemplate)
        locationImageView.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        blogImageView.image = UIImage(named: "blog")?.withRenderingMode(.alwaysTemplate)
        companyImageView.tintColor = textColor
        locationImageView.tintColor = textColor
        blogImageView.tintColor = textColor
    }
    
}

// MARK: - Layout

extension MyProfileTableViewCell {
    
    private func layout() {
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        companyImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: companyLabel.centerYAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        companyLabel.leadingAnchor.constraint(equalTo: companyImageView.trailingAnchor, constant: 4).isActive = true
        companyLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8).isActive = true
        companyLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        locationImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        locationImageView.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        locationImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 4).isActive = true
        locationLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        blogImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        blogImageView.centerYAnchor.constraint(equalTo: blogLabel.centerYAnchor).isActive = true
        blogImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        blogImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        blogLabel.leadingAnchor.constraint(equalTo: blogImageView.trailingAnchor, constant: 4).isActive = true
        blogLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8).isActive = true
        blogLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: blogLabel.bottomAnchor, constant: 16).isActive = true
    }
    
}
