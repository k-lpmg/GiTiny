//
//  SearchUsersCollectionViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa

final class SearchUsersCollectionViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: SearchUsersViewModel
    private let pageRelay: BehaviorRelay<Int>
    private let modelSelected: PublishRelay<SearchUser> = .init()
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
            return flowLayout
        }()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 4
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellType: SearchUserCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: SearchUsersViewModel, query: Driver<String>, sort: Driver<GitHubSearchService.UsersSort>, page: Int, perPage: Int) {
        self.viewModel = viewModel
        self.pageRelay = .init(value: page)
        super.init(nibName: nil, bundle: nil)
        
        bindViewModel(query: query, sort: sort, perPage: perPage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        view.addSubview(collectionView)
        layout()
    }
    
    // MARK: - Binding
    
    private func bindViewModel(query: Driver<String>, sort: Driver<GitHubSearchService.UsersSort>, perPage: Int) {
        // Input
        let theme = AppAppearance.shared.theme.mapToVoid().asDriverOnErrorJustNever()
        let request = Driver.combineLatest(query, sort) { (query, sort) in
            return SearchUsersViewModel.Request(page: 1, query: query, sort: sort)
        }
        let input = type(of: viewModel).Input(theme: theme,
                                              request: request,
                                              perPage: perPage,
                                              modelSelected: modelSelected.asDriverOnErrorJustNever())
        
        // Output
        let output = viewModel.transform(input: input)
        output.searchUsers
            .do(onNext: { [weak self] (_) in
                guard let self = self, self.collectionView.numberOfItems(inSection: 0) > 0 else {return}
                
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            })
            .drive(collectionView.rx.items(cellIdentifier: SearchUserCollectionViewCell.reuseIdentifier,
                                      cellType: SearchUserCollectionViewCell.self)) { index, model, cell in
                                        cell.configure(with: model, isHiddenLineView: true)
                                        cell.itemSelected
                                            .bind(onNext: { [weak self] (user) in
                                                guard let self = self else {return}
                                                
                                                self.modelSelected.accept(user)
                                            })
                                            .disposed(by: cell.cellDisposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .clear
        collectionView.delegate = self
    }
    
}

// MARK: - Layout

extension SearchUsersCollectionViewController {
    
    private func layout() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchUsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
