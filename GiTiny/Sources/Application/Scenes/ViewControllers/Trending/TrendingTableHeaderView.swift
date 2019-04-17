//
//  TrendingTableHeaderView.swift
//  GiTiny
//
//  Created by DongHeeKang on 28/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class TrendingTableHeaderView: UIView {
    
    // MARK: - Properties
    
    let selectedLanguage: PublishRelay<TrendingLanguage> = .init()
    let selectedSince: PublishRelay<Since> = .init()
    
    private var appearanceModeChanged: Binder<AppTheme> {
        return Binder(self) { me, value in
            me.backgroundColor = value.backgroundColor
        }
    }
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let languageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    let sinceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    // MARK: - Con(De)structor
    
    convenience init() {
        self.init(frame: .zero)
        
        bindView()
        addSubview(languageButton)
        addSubview(sinceButton)
        layout()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        AppAppearance.shared.theme
            .bind(to: appearanceModeChanged)
            .disposed(by: disposeBag)
        selectedLanguage
            .map { $0.name }
            .bind(to: languageButton.rx.title())
            .disposed(by: disposeBag)
        selectedSince
            .map { $0.upperTitle.localized }
            .bind(to: sinceButton.rx.title())
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension TrendingTableHeaderView {
    
    private func layout() {
        languageButton.trailingAnchor.constraint(equalTo: sinceButton.leadingAnchor, constant: -16).isActive = true
        languageButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        
        sinceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        sinceButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
    }
    
}
