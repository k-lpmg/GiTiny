//
//  MyProfileLoginViewController.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

import FluidHighlighter
import RxCocoa
import RxSwift

final class MyProfileLoginViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: MyProfileLoginViewModel
    
    // MARK: - UI Components
    
    private let headDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The GitHub API is limited to 60 API requests per hour if not authenticated.\n(If you are authenticated, 5000 API calls per hour are possible.)".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    private let signInGitHubButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "github"), for: .normal)
        button.setTitle("Sign in with GitHub".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.layer.cornerRadius = 4
        
        let spacing: CGFloat = 6
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: spacing, bottom: 0.0, right: -spacing)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: spacing+16)
        return button
    }()
    
    // MARK: - Con(De)structor
    
    init(viewModel: MyProfileLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setProperties()
        view.addSubview(headDescriptionLabel)
        view.addSubview(signInGitHubButton)
        layout()
    }
    
    override func updateAppearance(from theme: AppTheme, me: BaseViewController) {
        super.updateAppearance(from: theme, me: me)
        
        guard let me = me as? MyProfileLoginViewController else {return}
        
        me.headDescriptionLabel.textColor = theme.textColor
        me.signInGitHubButton.fh.controlEnable(normalColor: UIColor.gray, highlightedColor: UIColor.darkGray)
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {
        // Input
        let trigger = signInGitHubButton.rx.tap.asDriverOnErrorJustNever()
        let input = type(of: viewModel).Input(authTrigger: trigger)
        
        // Output
        let output = viewModel.transform(input: input)
        output.accessToken
            .drive(GitHubAccessManager.shared.accessToken)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .clear
    }
    
}

// MARK: - Layout

extension MyProfileLoginViewController {
    
    private func layout() {
        headDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        headDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        headDescriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32).isActive = true
        
        signInGitHubButton.topAnchor.constraint(equalTo: headDescriptionLabel.bottomAnchor, constant: 16).isActive = true
        signInGitHubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
