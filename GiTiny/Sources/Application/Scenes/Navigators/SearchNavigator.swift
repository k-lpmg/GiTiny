//
//  SearchNavigator.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import PanModal
import RxCocoa
import RxSwift

final class SearchNavigator: Navigator {
    
    // MARK: - Properties
    
    unowned private let navigationController: UINavigationController
    
    // MARK: - Con(De)structor
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal methods
    
    func initial(animated: Bool) {
        let searchText: BehaviorRelay<String?> = .init(value: nil)
        let repositoriesSort: BehaviorRelay<GitHubSearchService.RepositoriesSort> = .init(value: .bestMatch)
        let usersSort: BehaviorRelay<GitHubSearchService.UsersSort> = .init(value: .bestMatch)
        
        let repositoriesCollectionVC = SearchRepositoriesCollectionViewController(viewModel: .init(navigator: self,
                                                                                                   useCase: .init()),
                                                                                  query: searchText.filter { $0 != nil}.map { $0! }.asDriverOnErrorJustNever(),
                                                                                  sort: repositoriesSort.asDriver(),
                                                                                  page: 1,
                                                                                  perPage: 10)
        let usersCollectionVC = SearchUsersCollectionViewController(viewModel: .init(navigator: self,
                                                                                     useCase: .init()),
                                                                    query: searchText.filter { $0 != nil}.map { $0! }.asDriverOnErrorJustNever(),
                                                                    sort: usersSort.asDriver(),
                                                                    page: 1,
                                                                    perPage: 10)
        let controller = SearchViewController(viewModel: .init(navigator: self),
                                              searchText: searchText,
                                              repositoriesCollectionVC: repositoriesCollectionVC,
                                              usersCollectionVC: usersCollectionVC)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func pushRepositories(searchedText: String?) {
        let searchedTextRelay: BehaviorRelay<String?> = .init(value: searchedText)
        let controller = SearchRepositoriesTableViewController(viewModel: .init(navigator: self,
                                                                                useCase: .init()),
                                                               searchedText: searchedTextRelay.asDriver())
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pushUsers(searchedText: String?) {
        let searchedTextRelay: BehaviorRelay<String?> = .init(value: searchedText)
        let controller = SearchUsersTableViewController(viewModel: .init(navigator: self,
                                                                         useCase: .init()),
                                                        searchedText: searchedTextRelay.asDriver())
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentPanModalWeb(_ url: String) {
        navigationController.presentPanModal(WebViewController(viewModel: .init(), urlString: url))
    }
    
}
