//
//  BaseNavigationController.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseNavigationController: UINavigationController, AppearanceChangeable {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Overridden: UINavigationController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppAppearance.shared.theme.value.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        bindAppearance()
    }
    
    // MARK: - AppearanceChangeable
    
    func updateAppearance(from theme: AppTheme, me: BaseNavigationController) {
        me.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Binding
    
    private func bindAppearance() {
        AppAppearance.shared.theme
            .bind(to: appearanceUpdated)
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        navigationBar.shadowImage = UIImage()
        navigationBar.shouldRemoveShadow(true)
    }
    
}
