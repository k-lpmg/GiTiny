//
//  SeeMoreView.swift
//  GiTiny
//
//  Created by DongHeeKang on 18/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class SeeMoreView: BaseView {
    
    // MARK: - Properties
    
    lazy var seeMoreButtonClickEvent: ControlEvent<Void> = {
        return seeMoreButton.rx.tap
    }()
    
    // MARK: - UI Components
    
    let contentView: UIView
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        return button
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    init(title: String, contentView: UIView) {
        self.contentView = contentView
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        super.init()
        
        self.titleLabel.text = title
        layer.cornerRadius = 8
        addSubview(titleLabel)
        addSubview(seeMoreButton)
        addSubview(containerView)
        containerView.addSubview(contentView)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: UIView
    
    override func updateAppearance(from theme: AppTheme, me: BaseView) {
        super.updateAppearance(from: theme, me: me)
        
        titleLabel.textColor = theme.textColor
        backgroundColor = theme.subviewBackgroundColor
    }
    
}

// MARK: - Layout

extension SeeMoreView {
    
    private func layout() {
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: seeMoreButton.leadingAnchor, constant: -16).isActive = true
        titleLabel.setContentHuggingPriority(.init(0), for: .horizontal)
        
        seeMoreButton.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        layoutContentView()
    }
    
    private func layoutContentView() {
        contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
}
