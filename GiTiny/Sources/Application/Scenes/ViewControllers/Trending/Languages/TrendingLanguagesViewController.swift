//
//  TrendingLanguagesViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 16/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import FluidHighlighter
import RxCocoa
import RxDataSources
import RxSwift

final class TrendingLanguagesViewController: BaseViewController {
    
    // MARK: - Constants
    
    static var dataSource: RxTableViewSectionedReloadDataSource<LanguagesSection> {
        return RxTableViewSectionedReloadDataSource<LanguagesSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UITableViewCell.self)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let theme = AppAppearance.shared.theme.value
            cell.fh.enable(normalColor: theme.fluidNormalColor1, highlightedColor: theme.fluidHighlightColor)
            cell.textLabel?.textColor = theme.textColor
            
            switch item {
            case .all(let allLanguage):
                cell.textLabel?.text = allLanguage.name
            case .popular(let language), .other(let language):
                cell.textLabel?.text = language.name
            }
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
    }
    
    // MARK: - Properties
    
    let searchFilter: BehaviorSubject<String> = .init(value: "")
    let selectLanguage: PublishRelay<TrendingLanguage> = .init()
    
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<LanguagesSection> = type(of: self).dataSource
    private var viewModel: TrendingLanguagesViewModel
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: UITableViewCell.self)
        return tableView
    }()
    private let searchController: BaseSearchController = {
        let searchController = BaseSearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: TrendingLanguagesViewModel) {
        self.viewModel = viewModel
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
        setNavigation()
        setProperties()
        view.addSubview(tableView)
        layout()
    }
    
    // MARK: - Binding
    
    private func bindView() {
        let closeBarButtonItem: UIBarButtonItem = {
            let barButtonItem = UIBarButtonItem()
            barButtonItem.title = "Close".localized
            barButtonItem.style = .plain
            return barButtonItem
        }()
        navigationItem.leftBarButtonItem = closeBarButtonItem
        closeBarButtonItem.rx
            .tap
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else {return}
                
                self.searchController.dismiss(animated: false, completion: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx
            .text
            .orEmpty
            .bind(to: searchFilter)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(LanguageSectionItem.self)
            .map {
                switch $0 {
                case .all(let language), .popular(let language), .other(let language):
                    return language
                }
            }
            .do(onNext: { [weak self] (language) in
                guard let self = self else {return}
                
                self.searchController.dismiss(animated: false, completion: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .bind(to: selectLanguage)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // Input
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).mapToVoid()
        let itemSelected = tableView.rx.itemSelected
        itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let self = self else {return}
                
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        let input = type(of: viewModel).Input(trigger: viewWillAppear.asDriverOnErrorJustNever(),
                                              selection: itemSelected.asDriverOnErrorJustNever())
        
        // Output
        let output = viewModel.transform(input: input)
        Observable<[LanguagesSection]>
            .combineLatest(output.items.asObservable(), searchFilter) { (items, search) in
                guard !search.isEmpty else {return items}
                let sectionItems = items[2].items.filter({ (item) -> Bool in
                    switch item {
                    case .other(let language):
                        return language.name.range(of: search, options: .caseInsensitive) != nil
                    default:
                        return false
                    }
                })
                return [LanguagesSection.section(title: "Search".localized, items: sectionItems)]
            }
            .asDriverOnErrorJustNever()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setNavigation() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func setProperties() {
        definesPresentationContext = true
        navigationItem.title = "Select Languages".localized
        tableView.separatorStyle = .none
    }
    
}

// MARK: - Layout

extension TrendingLanguagesViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
