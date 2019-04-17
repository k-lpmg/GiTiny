//
//  AppearanceUICategory.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

enum AppearanceUICategory: CaseIterable {
    case tabBar
    case navigationBar
    case searchBar
    case segmentedControl
}

extension AppearanceUICategory {
    func configure(from theme: AppTheme) {
        let tintColor = theme.tintColor
        
        switch self {
        case .tabBar:
            let appearance = UITabBar.appearance()
            appearance.isTranslucent = false
            appearance.tintColor = .white
            appearance.barTintColor = theme.tabBarTintColor
        case .navigationBar:
            let appearance = UINavigationBar.appearance()
            appearance.isTranslucent = false
            appearance.tintColor = tintColor
            appearance.barTintColor = theme.navigationBarTintColor
            appearance.prefersLargeTitles = true
            let textAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
            appearance.titleTextAttributes = textAttributes
            appearance.largeTitleTextAttributes = textAttributes
        case .searchBar:
            let appearance = UISearchBar.appearance()
            appearance.tintColor = tintColor
        case .segmentedControl:
            let appearance = UISegmentedControl.appearance()
            appearance.tintColor = tintColor
        }
    }
}
