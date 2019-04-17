//
//  MyProfileViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class MyProfileViewController: BaseViewController {
    
    // MARK: - UI Components
    
    var loginViewController: MyProfileLoginViewController!
    var profileViewController: MyProfileTableViewController!
    
    private let refreshButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: nil, action: nil)
        return barButtonItem
    }()
    
    // MARK: - Con(De)structor
    
    init(refresh: PublishRelay<Void>) {
        super.init(nibName: nil, bundle: nil)
        
        refreshButtonItem.rx
            .tap
            .bind(to: refresh)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        setProperties()
    }
    
    // MARK: - Private methods
    
    private func bindView() {
        GitHubAccessManager.shared.accessToken
            .subscribe(onNext: { [weak self] (accessToken) in
                guard let self = self else {return}
                
                self.children.forEach({ (viewController) in
                    viewController.willMove(toParent: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                })
                
                let childViewController: UIViewController = accessToken == nil ? self.loginViewController : self.profileViewController
                let superView = self.view!
                self.addChild(childViewController)
                superView.addSubview(childViewController.view)
                childViewController.view.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
                childViewController.view.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
                childViewController.view.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
                childViewController.view.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
            })
            .disposed(by: disposeBag)
    }
    
    private func setProperties() {
        navigationItem.title = "My Profile".localized
        navigationItem.rightBarButtonItem = refreshButtonItem
    }
    
}
