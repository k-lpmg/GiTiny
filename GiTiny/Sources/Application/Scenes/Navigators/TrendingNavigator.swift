//
//  TrendingNavigator.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import SafariServices
import UIKit

import PanModal
import RxCocoa

final class TrendingNavigator: Navigator {
    
    // MARK: - Properties
    
    unowned private let navigationController: UINavigationController
    
    // MARK: - Con(De)structor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal methods
    
    func initial(animated: Bool) {
        func getChildTableVC<T>(from type: TrendingType) -> T where T: BaseViewController {
            let viewController: T
            switch type {
            case .repositories:
                viewController = TrendingRepositoriesTableViewController(viewModel: .init(navigator: self, useCase: .init())) as! T
            case .developers:
                viewController = TrendingDevelopersTableViewController(viewModel: .init(navigator: self, useCase: .init())) as! T
            }
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            return viewController
        }
        
        let controller = TrendingViewController(repositoriesViewController: getChildTableVC(from: .repositories),
                                                developersViewController: getChildTableVC(from: .developers))
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func presentLanguages() -> PublishRelay<TrendingLanguage> {
        let rootViewController = TrendingLanguagesViewController(viewModel: .init(useCase: .init()))
        navigationController.present(BaseNavigationController(rootViewController: rootViewController), animated: true, completion: nil)
        return rootViewController.selectLanguage
    }
    
    func presentPanModalWeb(_ url: String) {
        navigationController.presentPanModal(WebViewController(viewModel: .init(), urlString: url))
    }
    
}
