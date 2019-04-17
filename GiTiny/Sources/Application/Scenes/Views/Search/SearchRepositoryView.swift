//
//  SearchRepositoryView.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

final class SearchRepositoryView: UIView {
    
    // MARK: - UI Components
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    private let starredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    private let starredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    private let licenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .darkGray
        return label
    }()
    private let updatedAtLabel: UILabel = {
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
        
        addSubview(fullnameLabel)
        addSubview(languageLabel)
        addSubview(starredImageView)
        addSubview(starredLabel)
        addSubview(descriptionLabel)
        addSubview(licenseLabel)
        addSubview(updatedAtLabel)
        addSubview(lineView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func configure(with model: SearchRepository, isHiddenLineView: Bool? = nil) {
        fullnameLabel.text = model.full_name
        languageLabel.text = model.language
        descriptionLabel.text = model.description
        licenseLabel.text = model.license?.name
        
        let starCount = model.stargazers_count
        if starCount >= 1000 {
            let count: Float = Float(starCount) / 1000.0
            starredLabel.text = String(format: "%.1fk", count)
        } else {
            starredLabel.text = starCount.stringValue
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let updatedAt = dateFormatter.date(from: model.updated_at) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let updatedAtString = dateFormatter.string(from: updatedAt)
            updatedAtLabel.text = "Updated on " + updatedAtString
        }
        
        let theme = AppAppearance.shared.theme.value
        fh.enable(normalColor: theme.fluidNormalColor1, highlightedColor: theme.fluidHighlightColor)
        fullnameLabel.textColor = theme.systemDefaultTextColor
        starredImageView.changePngColorTo(color: theme.imageTintColor)
        lineView.backgroundColor = theme.lineColor
        
        if let isHidden = isHiddenLineView {
            lineView.isHidden = isHidden
        }
    }
    
    func reset() {
        fullnameLabel.text = nil
        languageLabel.text = nil
        starredLabel.text = nil
        descriptionLabel.text = nil
        licenseLabel.text = nil
        updatedAtLabel.text = nil
    }
    
}

// MARK: - Layout

extension SearchRepositoryView {
    
    private func layout() {
        fullnameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        fullnameLabel.setContentHuggingPriority(.init(1000), for: .vertical)
        
        languageLabel.leadingAnchor.constraint(equalTo: fullnameLabel.trailingAnchor, constant: 8).isActive = true
        languageLabel.trailingAnchor.constraint(equalTo: starredImageView.leadingAnchor, constant: -16).isActive = true
        languageLabel.centerYAnchor.constraint(equalTo: fullnameLabel.centerYAnchor).isActive = true
        languageLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        languageLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        starredImageView.trailingAnchor.constraint(equalTo: starredLabel.leadingAnchor, constant: -4).isActive = true
        starredImageView.centerYAnchor.constraint(equalTo: fullnameLabel.centerYAnchor).isActive = true
        starredImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        starredImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        starredLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        starredLabel.centerYAnchor.constraint(equalTo: fullnameLabel.centerYAnchor).isActive = true
        starredLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        starredLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        licenseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        licenseLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        licenseLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        updatedAtLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        updatedAtLabel.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor).isActive = true
        updatedAtLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
