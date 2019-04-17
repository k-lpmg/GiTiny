//
//  MyProfileTableViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class MyProfileTableViewController: BaseViewController {
    
    // MARK: - Constants
    
    static var dataSource: RxTableViewSectionedReloadDataSource<MyProfileSection> {
        return RxTableViewSectionedReloadDataSource<MyProfileSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            switch item {
            case .profile(let user):
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MyProfileTableViewCell.self)
                cell.configure(user: user)
                return cell
            case .repositories, .followers, .following:
                let subTitle: String
                switch item {
                case .repositories(let user):
                    subTitle = "\(user?.public_repos ?? 0)"
                case .followers(let user):
                    subTitle = "\(user?.followers ?? 0)"
                case .following(let user):
                    subTitle = "\(user?.following ?? 0)"
                default:
                    subTitle = ""
                }
                
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SubtitleTableViewCell.self)
                cell.configure(title: item.title, subTitle: subTitle)
                return cell
            case .stars:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
                cell.configure(title: item.title)
                return cell
            }
        })
    }
    
    // MARK: - Properties
    
    private let viewModel: MyProfileTableViewModel
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: MyProfileTableViewCell.self)
        tableView.register(cellType: BaseTableViewCell.self)
        tableView.register(cellType: SubtitleTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: MyProfileTableViewModel, refresh: Observable<Void>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindViewModel(refresh: refresh)
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
        
        guard let me = me as? MyProfileTableViewController else {return}
        
        me.tableView.backgroundColor = theme.tableViewBackgroundColor
        me.tableView.separatorColor = theme.tableViewSeparatorColor
    }
    
    // MARK: - Binding
    
    private func bindViewModel(refresh: Observable<Void>) {
        // Input
        let theme = AppAppearance.shared.theme.mapToVoid().asDriverOnErrorJustNever()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .take(1)
            .mapToVoid()
        let trigger = Observable.merge(viewWillAppear, refresh)
        let accessToken = GitHubAccessManager.shared.accessToken
        let request = Observable
            .combineLatest(trigger, accessToken) { $1 }
        let selection = tableView.rx.modelSelected(UserProfileSectionItem.self).asDriver()
        let input = type(of: viewModel).Input(theme: theme, request: request.asDriverOnErrorJustNever(), selection: selection)
        
        // Output
        let output = viewModel.transform(input: input)
        output.sections
            .drive(tableView.rx.items(dataSource: type(of: self).dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .clear
    }
    
}

// MARK: - Layout

extension MyProfileTableViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
