//
//  BaseView.swift
//  GiTiny
//
//  Created by DongHeeKang on 20/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxSwift

class BaseView: UIView, AppearanceChangeable {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Con(De)structor
    
    init() {
        super.init(frame: .zero)
        
        bindAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Binding
    
    private func bindAppearance() {
        AppAppearance.shared.theme
            .bind(to: appearanceUpdated)
            .disposed(by: disposeBag)
    }
    
    // MARK: - AppearanceChangeable
    
    func updateAppearance(from theme: AppTheme, me: BaseView) {
        backgroundColor = theme.backgroundColor
    }
    
}
