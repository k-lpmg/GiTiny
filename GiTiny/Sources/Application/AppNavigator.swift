//
//  AppNavigator.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import RxSwift

final class AppNavigator {
    
    static let shared = AppNavigator()
    
    // MARK: - Internal methods
    
    func start(in window: UIWindow) {
        let trendingNavigationController = getNavigationController(from: .trending)
        let searchNavigationController = getNavigationController(from: .search)
        let githubNavigationController = getNavigationController(from: .myProfile)
        let settingNavigationController = getNavigationController(from: .setting)
        navigatorInitial(from: .trending, with: trendingNavigationController)
        navigatorInitial(from: .search, with: searchNavigationController)
        navigatorInitial(from: .myProfile, with: githubNavigationController)
        navigatorInitial(from: .setting, with: settingNavigationController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trendingNavigationController,
                                            searchNavigationController,
                                            githubNavigationController,
                                            settingNavigationController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Private methods
    
    private func getNavigationController(from type: SceneType) -> UINavigationController {
        let navigationController = BaseNavigationController()
        navigationController.tabBarItem = type.tabBarItem
        return navigationController
    }
    
    private func navigatorInitial(from type: SceneType, with navigationController: UINavigationController) {
        let navigator: Navigator
        switch type {
        case .trending:
            navigator = TrendingNavigator(navigationController: navigationController)
        case .search:
            navigator = SearchNavigator(navigationController: navigationController)
        case .myProfile:
            navigator = MyProfileNavigator(navigationController: navigationController)
        case .setting:
            navigator = SettingNavigator(navigationController: navigationController)
        }
        navigator.initial(animated: false)
    }
    
}
