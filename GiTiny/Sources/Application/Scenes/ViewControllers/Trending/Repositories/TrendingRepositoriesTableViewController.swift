//
//  TrendingRepositoriesTableViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 02/01/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import Moya
import RxCocoa
import RxDataSources
import RxSwift

final class TrendingRepositoriesTableViewController: BaseViewController {
    
    // MARK: - Properties
    
    let languageButtonClick: PublishRelay<Void> = .init()
    let selectedLanguage: BehaviorRelay<TrendingLanguage> = {
        let userDefaults = UserDefaults.standard
        guard let lastUrlParm = userDefaults.object(forKey: UserDefaultsKey.kLastSearchLanguageUrlParamInTrendingRepositories) as? String,
            let lastName = userDefaults.object(forKey: UserDefaultsKey.kLastSearchLanguageNameInTrendingRepositories) as? String else {
                return .init(value: TrendingLanguage.all)
        }
        
        let lastValue = TrendingLanguage(urlParam: lastUrlParm, name: lastName)
        return .init(value: lastValue)
    }()
    let selectedSince: BehaviorRelay<Since> = .init(value: .daily)
    
    private var viewModel: TrendingRepositoriesTableViewModel
    private var refreshControlFecting: Binder<Bool> {
        return Binder(refreshControl) { (refreshControl, value) in
            value ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        }
    }
    private var tableViewDeselect: Binder<IndexPath> {
        return Binder(tableView) { (tableView, value) in
            tableView.deselectRow(at: value, animated: true)
        }
    }
    private var sinceActions: [RxAlertAction<String>] {
        var actions = [RxAlertAction<String>]()
        Since.allCases.forEach { (since) in
            let action = RxAlertAction<String>.init(title: since.upperTitle.localized, style: .default, result: since.rawValue)
            actions.append(action)
        }
        let cancelAction = RxAlertAction<String>.init(title: "Cancel".localized, style: .cancel, result: "")
        actions.append(cancelAction)
        return actions
    }
    
    // MARK: - UI Components
    
    private let tableHeaderView: TrendingTableHeaderView = {
        let headerView = TrendingTableHeaderView()
        return headerView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: TrendingRepositoryTableViewCell.self)
        return tableView
    }()
    private let refreshControl: UIRefreshControl = .init()
    
    // MARK: - Con(De)structor
    
    init(viewModel: TrendingRepositoriesTableViewModel) {
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
        bindTableHeaderView()
        bindViewModel()
        setProperties()
        view.addSubview(tableView)
        layout()
    }
    
    // MARK: - Binding
    
    private func bindView() {
        selectedLanguage
            .bind(to: tableHeaderView.selectedLanguage)
            .disposed(by: disposeBag)
        selectedSince
            .bind(to: tableHeaderView.selectedSince)
            .disposed(by: disposeBag)
    }
    
    private func bindTableHeaderView() {
        tableHeaderView.languageButton.rx
            .tap
            .bind(to: languageButtonClick)
            .disposed(by: disposeBag)
        tableHeaderView.sinceButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}

                let sinceAlertController = UIAlertController.rx_presentAlert(viewController: self,
                                                                             preferredStyle: .alert,
                                                                             animated: true,
                                                                             actions: self.sinceActions)
                sinceAlertController
                    .subscribe(onNext: { [weak self] (since) in
                        guard let self = self, let since = Since.init(rawValue: since) else {return}
                        self.selectedSince.accept(since)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        tableView.rx
            .itemSelected
            .bind(to: tableViewDeselect)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // Input
        let theme = AppAppearance.shared.theme.mapToVoid().asDriverOnErrorJustNever()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .take(1)
            .mapToVoid()
        let pullToRefresh = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        let trigger = Observable.merge(viewWillAppear, pullToRefresh)
        let parameter = Observable.combineLatest(selectedLanguage, selectedSince) { ($0, $1) }
        let serviceParameters: Driver<(String?, Since)> = Observable.combineLatest(trigger, parameter) { ($1.0.name, $1.1) }.asDriverOnErrorJustNever()
        let modelSelected = tableView.rx.modelSelected(TrendingRepository.self).asDriver()
        let input = type(of: viewModel).Input(theme: theme,
                                              serviceParameters: serviceParameters,
                                              modelSelected: modelSelected,
                                              languageButtonClick: languageButtonClick.asDriverOnErrorJustNever())
        
        // Output
        let output = viewModel.transform(input: input)
        output.fetching
            .drive(refreshControlFecting)
            .disposed(by: disposeBag)
        output.repositories
            .drive(tableView.rx.items(cellIdentifier: TrendingRepositoryTableViewCell.reuseIdentifier,
                                      cellType: TrendingRepositoryTableViewCell.self)) { [weak selectedSince] index, model, cell in
                                        guard let selectedSince = selectedSince else {return}
                                        
                                        cell.configure(with: model, since: selectedSince.value)
            }
            .disposed(by: disposeBag)
        output.selectedLanguage
            .drive(selectedLanguage)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension TrendingRepositoriesTableViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

// MARK: - UITableViewDelegate

extension TrendingRepositoriesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}
