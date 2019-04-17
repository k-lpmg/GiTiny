//
//  SearchUsersTableViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import AwaitToast
import RxCocoa
import RxSwift

final class SearchUsersTableViewController: BaseViewController {
    
    // MARK: - Constants
    
    private enum Const {
        static let perPage = 15
    }
    
    // MARK: - Properties
    
    private let viewModel: SearchUsersViewModel
    private let textDidEndEditing: Observable<Void>
    private let searchTrigger: Observable<String>
    private let sort: BehaviorRelay<GitHubSearchService.UsersSort>
    private let query: Observable<(String, GitHubSearchService.UsersSort)>
    private let pageRelay: BehaviorRelay<Int>
    
    private var sortActions: [RxAlertAction<String>] {
        var actions = [RxAlertAction<String>]()
        GitHubSearchService.UsersSort.allCases.forEach { (sort) in
            let action = RxAlertAction<String>.init(title: sort.title, style: .default, result: sort.rawValue)
            actions.append(action)
        }
        let cancelAction = RxAlertAction<String>.init(title: "Cancel".localized, style: .cancel, result: "")
        actions.append(cancelAction)
        return actions
    }
    
    // MARK: - UI Components
    
    private let searchController: BaseSearchController = {
        let searchController = BaseSearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.rowHeight = 100
        tableView.register(cellType: SearchUserTableViewCell.self)
        return tableView
    }()
    private let sortBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)
        return barButtonItem
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: SearchUsersViewModel, searchedText: Driver<String?>) {
        self.viewModel = viewModel
        textDidEndEditing = searchController.searchBar.rx
            .textDidEndEditing
            .mapToVoid()
        searchTrigger = searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .filter { $0.count > 0 }
        sort = .init(value: .bestMatch)
        query = Observable.combineLatest(searchTrigger, sort)
        pageRelay = .init(value: 1)
        
        super.init(nibName: nil, bundle: nil)
        
        bindView(searchedText: searchedText)
        bindViewModel(searchedText: searchedText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        view.addSubview(tableView)
        layout()
    }
    
    // MARK: - Binding
    
    private func bindView(searchedText: Driver<String?>) {
        rx.sentMessage(#selector(UIViewController.viewDidAppear(_:))).take(1)
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.searchController.isActive = true
            }
            .disposed(by: disposeBag)
        rx.sentMessage(#selector(UIViewController.viewDidDisappear(_:))).take(1)
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.searchController.isActive = false
            }
            .disposed(by: disposeBag)
        sort
            .bind { [weak self] (sort) in
                guard let self = self else {return}
                
                self.sortBarButtonItem.title = "Sort: " + sort.title
            }
            .disposed(by: disposeBag)
        sortBarButtonItem.rx
            .tap
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                let sinceAlertController = UIAlertController.rx_presentAlert(viewController: self,
                                                                             preferredStyle: .alert,
                                                                             animated: true,
                                                                             actions: self.sortActions)
                sinceAlertController
                    .subscribe(onNext: { [weak self] (sort) in
                        guard let self = self, let sort = GitHubSearchService.UsersSort.init(rawValue: sort) else {return}
                        self.sort.accept(sort)
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        let trigger = Observable<Void>.merge(textDidEndEditing, sort.mapToVoid())
        trigger.withLatestFrom(query)
            .bind { [weak self] (query) in
                guard let self = self else {return}
                
                self.tableView.scrollToTop(animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.pageRelay.accept(1)
                })
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel(searchedText: Driver<String?>) {
        // Input
        let previouslySearched = searchedText.filter { $0 != nil }.map { $0! }.asObservable().take(1)
        let theme = AppAppearance.shared.theme.mapToVoid().asDriverOnErrorJustNever()
        let search = Observable.merge(textDidEndEditing.map { "" }, previouslySearched)
        let trigger = Observable.combineLatest(search, pageRelay) { $1 }
        let request = Observable<SearchUsersViewModel.Request>.create { [weak self] (observer) -> Disposable in
            guard let self = self else {return Disposables.create()}
            
            previouslySearched
                .bind(onNext: { [weak self] (searchedText) in
                    guard let self = self, searchedText.count > 0 else {return}
                    
                    self.searchController.searchBar.text = searchedText
                    let page = 1
                    self.pageRelay.accept(page)
                    observer.onNext(.init(page: page, query: (searchedText), sort: self.sort.value))
                })
                .disposed(by: self.disposeBag)
            trigger
                .bind(onNext: { [weak self] (page) in
                    guard let self = self, let text = self.searchController.searchBar.text, text.count > 0 else {return}
                    
                    observer.onNext(.init(page: page, query: text, sort: self.sort.value))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
        let modelSelected = tableView.rx.modelSelected(SearchUser.self).asDriver()
        let input = type(of: viewModel).Input(theme: theme,
                                              request: request.asDriverOnErrorJustNever(),
                                              perPage: Const.perPage,
                                              modelSelected: modelSelected)

        // Output
        let output = viewModel.transform(input: input)
        output.searchUsers
            .drive(tableView.rx.items(cellIdentifier: SearchUserTableViewCell.reuseIdentifier,
                                      cellType: SearchUserTableViewCell.self)) { index, model, cell in
                                        cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        output.apiRateLimit
            .drive(onNext: { (apiRateLimit) in
                Toast.default(text: apiRateLimit.message).show()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        definesPresentationContext = true
        navigationItem.title = "Search Users"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = sortBarButtonItem
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.separatorStyle = .none
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension SearchUsersTableViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

// MARK: - UITableViewDelegate

extension SearchUsersTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let pageValue = pageRelay.value
        let perPage = Const.perPage
        let checkRowCount = indexPath.row + 1
        guard checkRowCount/perPage == pageValue else {return}
        pageRelay.accept(pageValue+1)
    }
    
}
