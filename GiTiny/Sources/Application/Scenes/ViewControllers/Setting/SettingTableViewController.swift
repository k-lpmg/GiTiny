//
//  SettingTableViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class SettingTableViewController: BaseViewController {
    
    static var dataSource: RxTableViewSectionedReloadDataSource<SettingSection> {
        return RxTableViewSectionedReloadDataSource<SettingSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            switch item {
            case .darkTheme:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SwitchTableViewCell.self)
                let theme = AppAppearance.shared.theme.value
                cell.configure(title: "Dark Theme".localized, isOn: theme == .night)
                cell.uiSwitch.rx
                    .value
                    .skip(1)
                    .map { $0 ? AppTheme.night : AppTheme.day }
                    .bind(to: AppAppearance.shared.theme)
                    .disposed(by: cell.cellDisposeBag)
                return cell
            case .setREADME:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SwitchTableViewCell.self)
                let userDefaults = UserDefaults.standard
                var isOn = false
                if userDefaults.object(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository) != nil {
                    isOn = userDefaults.bool(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository)
                }
                cell.configure(title: "Start of the Repository to README".localized, isOn: isOn)
                cell.uiSwitch.rx
                    .value
                    .skip(1)
                    .bind(onNext: { (value) in
                        userDefaults.set(value, forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository)
                    })
                    .disposed(by: cell.cellDisposeBag)
                return cell
            case .giTinyRepo:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
                cell.configure(title: "GiTiny Repo".localized)
                return cell
            case .openSourceLicenses:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
                cell.configure(title: "OpenSource Licenses".localized)
                return cell
            case .logout:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
                cell.configure(title: "Logout".localized)
                return cell
            }
        })
    }
    
    // MARK: - Properties
    
    let viewModel: SettingViewModel
    
    private var logoutAction: [RxAlertAction<Bool>] {
        var actions = [RxAlertAction<Bool>]()
        actions.append(RxAlertAction<Bool>.init(title: "Logout".localized, style: .destructive, result: true))
        actions.append(RxAlertAction<Bool>.init(title: "Cancel".localized, style: .cancel, result: false))
        return actions
    }
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(cellType: SwitchTableViewCell.self)
        tableView.register(cellType: BaseTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindView()
        bindViewModel()
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
    
    override func updateAppearance(from theme: AppTheme, me: BaseViewController) {
        super.updateAppearance(from: theme, me: me)
        
        guard let me = me as? SettingTableViewController else {return}
        
        me.tableView.backgroundColor = theme.tableViewBackgroundColor
        me.tableView.separatorColor = theme.tableViewSeparatorColor
    }
    
    // MARK: - Binding
    
    private func bindView() {
        tableView.rx
            .modelSelected(SettingSectionItem.self)
            .bind(onNext: { [weak self] (item) in
                guard let self = self else {return}
                
                switch item {
                case .logout:
                    let logoutAlertController = UIAlertController.rx_presentAlert(viewController: self,
                                                                                  preferredStyle: .actionSheet,
                                                                                  animated: true,
                                                                                  actions: self.logoutAction)
                    logoutAlertController
                        .subscribe(onNext: { (action) in
                            guard action else {return}
                            
                            AccessTokenRealmManager().clear()
                            GitHubAccessManager.shared.accessToken.accept(nil)
                        })
                        .disposed(by: self.disposeBag)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // Input
        let theme = AppAppearance.shared.theme.mapToVoid().asDriverOnErrorJustNever()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .take(1)
            .mapToVoid()
        let accessToken = GitHubAccessManager.shared.accessToken.asObservable()
        let accessTokenTrigger = Observable.combineLatest(viewWillAppear, accessToken) { $1 }.asDriverOnErrorJustNever()
        let selection = tableView.rx.modelSelected(SettingSectionItem.self).asDriver()
        let input = type(of: viewModel).Input(theme: theme, accessTokenTrigger: accessTokenTrigger, selection: selection)
        
        // Output
        let output = viewModel.transform(input: input)
        output.sections
            .drive(tableView.rx.items(dataSource: type(of: self).dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        navigationItem.title = "Setting".localized
        view.backgroundColor = .clear
    }
    
}

// MARK: - Layout

extension SettingTableViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
