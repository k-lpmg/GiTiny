//
//  SubtitleTableViewCell.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Components
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    // MARK: - Con(De)structor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        contentView.addSubview(subTitleLabel)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal methods
    
    func configure(title: String, subTitle: String? = nil) {
        super.configure(title: title)
        
        let theme = AppAppearance.shared.theme.value
        
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = theme.textColor
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.textAlignment = .left
        textLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension SubtitleTableViewCell {
    
    private func layout() {
        textLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        textLabel?.trailingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor, constant: -8).isActive = true
        textLabel?.centerYAnchor.constraint(equalTo: subTitleLabel.centerYAnchor).isActive = true
        
        subTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subTitleLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
}
