//
//  AppAppearance.swift
//  GiTiny
//
//  Created by DongHeeKang on 20/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class AppAppearance {
    
    static let shared = AppAppearance()
    
    // MARK: - Properties
    
    let theme: BehaviorRelay<AppTheme> = {
        let themeRawValue = (UserDefaults.standard.object(forKey: UserDefaultsKey.kAppTheme) as? Int) ?? 0
        let theme = AppTheme(rawValue: themeRawValue) ?? .day
        let relay: BehaviorRelay<AppTheme> = .init(value: theme)
        return relay
    }()
    
    private var themeUpdated: Binder<AppTheme> {
        return .init(self) { (me, value) in
            UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKey.kAppTheme)
            
            AppearanceUICategory.allCases.forEach({ (category) in
                category.configure(from: value)
            })
            
            UIApplication.shared.refresh()
        }
    }
    private var disposeBag = DisposeBag()
    
    // MARK: - Internal methods
    
    func start() {
        theme.bind(to: themeUpdated)
            .disposed(by: disposeBag)
    }
    
}
