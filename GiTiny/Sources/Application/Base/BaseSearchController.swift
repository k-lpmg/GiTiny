//
//  BaseSearchController.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseSearchController: UISearchController, AppearanceChangeable {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Overridden: UISearchController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAppearance()
    }
    
    // MARK: - Binding
    
    private func bindAppearance() {
        AppAppearance.shared.theme
            .bind(to: appearanceUpdated)
            .disposed(by: disposeBag)
    }
    
    // MARK: - AppearanceChangeable
    
    func updateAppearance(from theme: AppTheme, me: BaseSearchController) {
        me.setNeedsStatusBarAppearanceUpdate()
        searchBar.textField?.textColor = theme.textColor
    }
    
}
