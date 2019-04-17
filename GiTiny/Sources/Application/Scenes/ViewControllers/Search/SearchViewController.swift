//
//  SearchViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class SearchViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: SearchViewModel
    
    // MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = true
        return searchBar
    }()
    private let searchText: BehaviorRelay<String?>
    private let repositoriesCollectionVC: SearchRepositoriesCollectionViewController
    private let usersCollectionVC: SearchUsersCollectionViewController
    
    private lazy var repositoriesSeeMoreView: SeeMoreView = {
        let view = SeeMoreView(title: "Repositories", contentView: repositoriesCollectionVC.view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var usersSeeMoreView: SeeMoreView = {
        let view = SeeMoreView(title: "Users", contentView: usersCollectionVC.view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: SearchViewModel,
         searchText: BehaviorRelay<String?>,
         repositoriesCollectionVC: SearchRepositoriesCollectionViewController,
         usersCollectionVC: SearchUsersCollectionViewController) {
        self.viewModel = viewModel
        self.searchText = searchText
        self.repositoriesCollectionVC = repositoriesCollectionVC
        self.usersCollectionVC = usersCollectionVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        bindViewModel()
        setProperties()
        addChild(repositoriesCollectionVC)
        addChild(usersCollectionVC)
        view.addSubview(searchBar)
        view.addSubview(repositoriesSeeMoreView)
        view.addSubview(usersSeeMoreView)
        layout()
    }
    
    override func updateAppearance(from theme: AppTheme, me: BaseViewController) {
        super.updateAppearance(from: theme, me: me)
        
        searchBar.textField?.backgroundColor = theme.subviewBackgroundColor
        searchBar.textField?.textColor = theme.textColor
    }
    
    // MARK: - Binding
    
    private func bindView() {
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1)
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                AppAppearance.shared.theme
                    .bind(onNext: { [weak self] (theme) in
                        guard let self = self else {return}
                        
                        self.searchBar.textField?.backgroundColor = theme.subviewBackgroundColor
                        self.searchBar.textField?.textColor = theme.textColor
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).skip(1)
            .bind { [weak self] (_) in
                guard let self = self else {return}

                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            }
            .disposed(by: disposeBag)
        view.rx
            .tapGesture()
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        searchBar.rx
            .searchButtonClicked
            .bind { [weak self] (_) in
                guard let self = self else {return}
                
                self.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        searchBar.rx
            .textDidEndEditing
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(to: self.searchText)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // Input
        let input = type(of: viewModel).Input(searchText: searchText.asDriverOnErrorJustNever(),
                                              repositoriesSeeMore: repositoriesSeeMoreView.seeMoreButtonClickEvent.asDriver(),
                                              usersSeeMore: usersSeeMoreView.seeMoreButtonClickEvent.asDriver())
        
        // Output
        _ = viewModel.transform(input: input)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        definesPresentationContext = true
        navigationItem.title = "Search".localized
    }
    
}

// MARK: - Layout

extension SearchViewController {
    
    private func layout() {
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        repositoriesSeeMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        repositoriesSeeMoreView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        repositoriesSeeMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        repositoriesSeeMoreView.heightAnchor.constraint(equalTo: usersSeeMoreView.heightAnchor).isActive = true
        
        usersSeeMoreView.topAnchor.constraint(equalTo: repositoriesSeeMoreView.bottomAnchor, constant: 16).isActive = true
        usersSeeMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        usersSeeMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        usersSeeMoreView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        usersSeeMoreView.heightAnchor.constraint(equalTo: repositoriesSeeMoreView.heightAnchor).isActive = true
    }
    
}
