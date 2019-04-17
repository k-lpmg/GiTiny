//
//  BaseViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseViewController: UIViewController, AppearanceChangeable {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - Overridden: UIViewController
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppAppearance.shared.theme.value.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAppearance()
    }
    
    // MARK: - AppearanceChangeable
    
    func updateAppearance(from theme: AppTheme, me: BaseViewController) {
        me.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Binding
    
    private func bindAppearance() {
        AppAppearance.shared.theme
            .bind(to: appearanceUpdated)
            .disposed(by: disposeBag)
    }
    
}
