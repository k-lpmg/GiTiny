//
//  MyProfileNavigator.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import SafariServices
import UIKit

import RxCocoa

final class MyProfileNavigator: Navigator {
    
    // MARK: - Properties
    
    unowned private let navigationController: UINavigationController
    
    // MARK: - Con(De)structor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal methods
    
    func initial(animated: Bool) {
        let refresh: PublishRelay<Void> = .init()
        
        func getChildVC<T>(from type: MyProfileType) -> T where T: BaseViewController {
            let viewController: T
            switch type {
            case .login:
                viewController = MyProfileLoginViewController(viewModel: .init(navigator: self, useCase: .init())) as! T
            case .profile:
                viewController = MyProfileTableViewController(viewModel: .init(navigator: self, useCase: .init()), refresh: refresh.asObservable()) as! T
            }
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            return viewController
        }
        
        let controller = MyProfileViewController(refresh: refresh)
        controller.loginViewController = getChildVC(from: .login)
        controller.profileViewController = getChildVC(from: .profile)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func presentPanModalWeb(_ url: String) {
        navigationController.presentPanModal(WebViewController(viewModel: .init(), urlString: url))
    }
    
}
