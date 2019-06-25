//
//  SettingNavigator.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import AcknowList

final class SettingNavigator: Navigator {
    
    // MARK: - Properties
    
    unowned private let navigationController: UINavigationController
    
    // MARK: - Con(De)structor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal methods
    
    func initial(animated: Bool) {
        let controller = SettingTableViewController(viewModel: .init(navigator: self))
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func presentPanModalWeb(_ url: String) {
        navigationController.presentPanModal(WebViewController(viewModel: .init(), urlString: url))
    }
    
    func pushOpenSourceLicenses() {
        let viewController = AcknowListViewController()
        viewController.view.backgroundColor = .white
        viewController.navigationController?.navigationBar.tintColor = .red
        navigationController.pushViewController(viewController, animated: true)
    }
    
}
