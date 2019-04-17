//
//  TrendingViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class TrendingViewController: BaseViewController {
    
    // MARK: - Properties
    
    let trendingType: BehaviorRelay<TrendingType> = .init(value: .repositories)
    
    // MARK: - UI Components
    
    private var repositoriesViewController: TrendingRepositoriesTableViewController
    private var developersViewController: TrendingDevelopersTableViewController
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "Trending".localized
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .clear
        TrendingType.allCases.forEach({ (type) in
            segmentControl.insertSegment(withTitle: type.title, at: type.rawValue, animated: true)
        })
        return segmentControl
    }()
    
    init(repositoriesViewController: TrendingRepositoriesTableViewController, developersViewController: TrendingDevelopersTableViewController) {
        self.repositoriesViewController = repositoriesViewController
        self.developersViewController = developersViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        addChild(repositoriesViewController)
        addChild(developersViewController)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(segmentControl)
        view.addSubview(repositoriesViewController.view)
        view.addSubview(developersViewController.view)
        layout()
    }
    
    override func updateAppearance(from theme: AppTheme, me: BaseViewController) {
        super.updateAppearance(from: theme, me: me)
        
        guard let me = me as? TrendingViewController else {return}
        
        me.titleLabel.textColor = theme.textColor
    }
    
    // MARK: - Binding
    
    private func bindView() {
        if let navigationController = navigationController {
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
                .map { _ in true }
                .bind(to: navigationController.navigationBar.rx.isHidden)
                .disposed(by: disposeBag)
            rx.sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
                .map { _ in false }
                .bind(to: navigationController.navigationBar.rx.isHidden)
                .disposed(by: disposeBag)
        }
        segmentControl.rx
            .controlEvent(.valueChanged)
            .map { [weak self] in
                guard let self = self else {return -1}
                
                return self.segmentControl.selectedSegmentIndex
            }
            .map { TrendingType(rawValue: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: trendingType)
            .disposed(by: disposeBag)
        let repositories = Observable.combineLatest(trendingType, repositoriesViewController.selectedSince) { ($0, $1) }
        let developers = Observable.combineLatest(trendingType, developersViewController.selectedSince) { ($0, $1) }
        Observable.merge(repositories, developers)
            .bind { [weak self] (type, since) in
                guard let self = self else {return}
                
                let sinceText = since.lowerTitle
                let descriptionSuffix: String = " ".appending(sinceText).appending(".")
                let description = type.description.appending(descriptionSuffix)
                self.descriptionLabel.text = description.localized
                self.segmentControl.selectedSegmentIndex = type.rawValue
                self.repositoriesViewController.view.isHidden = type != TrendingType.repositories
                self.developersViewController.view.isHidden = type != TrendingType.developers
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension TrendingViewController {
    
    private func layout() {
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        segmentControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        repositoriesViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        repositoriesViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
        repositoriesViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        repositoriesViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        developersViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        developersViewController.view.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8).isActive = true
        developersViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        developersViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
