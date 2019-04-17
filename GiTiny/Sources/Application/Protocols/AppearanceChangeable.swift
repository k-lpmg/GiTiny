//
//  AppearanceChangeable.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa

protocol AppearanceChangeable: class {
    var appearanceUpdated: Binder<AppTheme> { get }
    func updateAppearance(from theme: AppTheme, me: Self)
}

extension AppearanceChangeable {
    var appearanceUpdated: Binder<AppTheme> {
        return Binder(self) { me, value in
            me.updateAppearance(from: value, me: me)
        }
    }
}
