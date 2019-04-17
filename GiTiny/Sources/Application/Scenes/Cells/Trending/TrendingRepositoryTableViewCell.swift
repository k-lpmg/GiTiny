//
//  TrendingRepositoryTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 29/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import FluidHighlighter

final class TrendingRepositoryTableViewCell: UITableViewCell {
    
    // MARK: - NSLayoutConstraints
    
    private var starImageViewLeadingToLanguageLabel: NSLayoutConstraint!
    private var starImageViewLeadingToContentView: NSLayoutConstraint!
    
    // MARK: - UI Components
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    private let languageColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    private let starLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()
    private let forkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "fork")
        return imageView
    }()
    private let forkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()
    private let sinceStarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    private let sinceStarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()
    private let sinceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
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
        contentView.addSubview(authorLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(languageColorView)
        contentView.addSubview(languageLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(starLabel)
        contentView.addSubview(forkImageView)
        contentView.addSubview(forkLabel)
        contentView.addSubview(sinceStarImageView)
        contentView.addSubview(sinceStarLabel)
        contentView.addSubview(sinceLabel)
        contentView.addSubview(lineView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: UITableView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        languageColorView.layer.cornerRadius = 12/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.text = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        languageColorView.backgroundColor = nil
        languageLabel.text = nil
        starLabel.text = nil
        forkLabel.text = nil
        sinceStarLabel.text = nil
        sinceLabel.text = nil
    }
    
    // MARK: - Internal methods
    
    func configure(with model: TrendingRepository, since: Since) {
        let theme = AppAppearance.shared.theme.value
        
        fh.enable(normalColor: theme.fluidNormalColor1, highlightedColor: theme.fluidHighlightColor)
        
        authorLabel.text = model.author
        authorLabel.textColor = theme.systemDefaultTextColor
        
        nameLabel.text = "/ ".appending(model.name)
        nameLabel.textColor = theme.systemDefaultTextColor
        
        descriptionLabel.text = model.description
        
        starImageView.changePngColorTo(color: theme.imageTintColor)
        starLabel.text = model.stars.commaValue
        
        forkImageView.changePngColorTo(color: theme.imageTintColor)
        forkLabel.text = model.forks.commaValue
        
        sinceStarImageView.changePngColorTo(color: theme.imageTintColor)
        sinceStarLabel.text = model.currentPeriodStars.commaValue
        
        sinceLabel.text = "stars ".appending(since.lowerTitle.localized)
        
        lineView.backgroundColor = theme.lineColor
        
        var isExistLanguage: Bool = false
        if let color = model.languageColor, let language = model.language {
            languageColorView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
            languageLabel.text = language
            isExistLanguage = true
        }
        
        if starImageViewLeadingToContentView.isActive {
            starImageViewLeadingToContentView.isActive = !isExistLanguage
            starImageViewLeadingToLanguageLabel.isActive = isExistLanguage
        } else {
            starImageViewLeadingToLanguageLabel.isActive = isExistLanguage
            starImageViewLeadingToContentView.isActive = !isExistLanguage
        }
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension TrendingRepositoryTableViewCell {
    
    private func layout() {
        contentView.bottomAnchor.constraint(equalTo: sinceLabel.bottomAnchor, constant: 16).isActive = true
        
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        authorLabel.setContentHuggingPriority(.init(rawValue: 1000), for: .horizontal)
        
        nameLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor).isActive = true
        nameLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        languageColorView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        languageColorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        languageColorView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        languageColorView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        languageLabel.leadingAnchor.constraint(equalTo: languageColorView.trailingAnchor, constant: 8).isActive = true
        languageLabel.centerYAnchor.constraint(equalTo: languageColorView.centerYAnchor).isActive = true
        
        starImageView.centerYAnchor.constraint(equalTo: languageLabel.centerYAnchor).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        starImageViewLeadingToLanguageLabel = starImageView.leadingAnchor.constraint(equalTo: languageLabel.trailingAnchor, constant: 16)
        starImageViewLeadingToContentView = starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        
        starLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4).isActive = true
        starLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        
        forkImageView.leadingAnchor.constraint(equalTo: starLabel.trailingAnchor, constant: 16).isActive = true
        forkImageView.centerYAnchor.constraint(equalTo: starLabel.centerYAnchor).isActive = true
        
        forkLabel.leadingAnchor.constraint(equalTo: forkImageView.trailingAnchor, constant: 4).isActive = true
        forkLabel.centerYAnchor.constraint(equalTo: forkImageView.centerYAnchor).isActive = true
        
        sinceStarImageView.topAnchor.constraint(equalTo: forkLabel.bottomAnchor, constant: 16).isActive = true
        sinceStarImageView.trailingAnchor.constraint(equalTo: sinceStarLabel.leadingAnchor, constant: -4).isActive = true
        sinceStarImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        sinceStarImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true

        sinceStarLabel.trailingAnchor.constraint(equalTo: sinceLabel.leadingAnchor, constant: -4).isActive = true
        sinceStarLabel.centerYAnchor.constraint(equalTo: sinceStarImageView.centerYAnchor).isActive = true
        
        sinceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        sinceLabel.centerYAnchor.constraint(equalTo: sinceStarImageView.centerYAnchor).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
}
