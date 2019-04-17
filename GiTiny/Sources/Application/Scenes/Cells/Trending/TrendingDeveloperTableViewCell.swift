//
//  TrendingDeveloperTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 29/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import FluidHighlighter
import Kingfisher
import RxSwift

final class TrendingDeveloperTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .gray
        return label
    }()
    private let repositoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "repository_white")
        return imageView
    }()
    private let repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .lightGray
        return label
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        contentView.addSubview(rankLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(repositoryImageView)
        contentView.addSubview(repositoryNameLabel)
        contentView.addSubview(lineView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rankLabel.text =  nil
        usernameLabel.text = nil
        nameLabel.text = nil
        repositoryNameLabel.text = nil
        avatarImageView.image = nil
    }
    
    // MARK: - Internal methods
    
    func configure(with model: TrendingDeveloper, index: Int) {
        let theme = AppAppearance.shared.theme.value
        
        fh.enable(normalColor: theme.fluidNormalColor1, highlightedColor: theme.fluidHighlightColor)
        
        rankLabel.text = "\(index+1)"
        
        usernameLabel.text = model.username
        usernameLabel.textColor = theme.systemDefaultTextColor
        
        nameLabel.text = model.name == nil ? "" : "(\(model.name!))"
        
        repositoryNameLabel.text = model.repo.name
        
        avatarImageView.kf.setImage(with: URL(string: model.avatar)!)
        
        lineView.backgroundColor = theme.lineColor
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension TrendingDeveloperTableViewCell {
    
    private func layout() {
        contentView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24).isActive = true
        
        rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        rankLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        rankLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        avatarImageView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 8).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: rankLabel.topAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -8).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        usernameLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        nameLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        repositoryImageView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        repositoryImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16).isActive = true
        repositoryImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        repositoryImageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        repositoryNameLabel.leadingAnchor.constraint(equalTo: repositoryImageView.trailingAnchor, constant: 4).isActive = true
        repositoryNameLabel.centerYAnchor.constraint(equalTo: repositoryImageView.centerYAnchor).isActive = true
        repositoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
}
