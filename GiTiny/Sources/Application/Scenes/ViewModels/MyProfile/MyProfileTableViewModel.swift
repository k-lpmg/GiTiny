//
//  MyProfileTableViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift

final class MyProfileTableViewModel {
    
    private let navigator: MyProfileNavigator
    private let useCase: UserProfileUseCase
    private var disposeBag = DisposeBag()
    
    init(navigator: MyProfileNavigator, useCase: UserProfileUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension MyProfileTableViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let request: Driver<AccessToken?>
        let selection: Driver<UserProfileSectionItem>
    }
    struct Output {
        let sections: Driver<[MyProfileSection]>
    }
    
    func transform(input: Input) -> Output {
        let sectionsReplay: PublishRelay<[MyProfileSection]> = .init()
        input.request
            .do(onNext: { (accessToken) in
                guard accessToken == nil else {return}
                let emptySections: [MyProfileSection] = [.section(items: [.profile(user: nil)]),
                                                           .section(items: [.repositories(user: nil)]),
                                                           .section(items: [.stars(user: nil)]),
                                                           .section(items: [.followers(user: nil)]),
                                                           .section(items: [.following(user: nil)])]
                sectionsReplay.accept(emptySections)
            })
            .filter { $0 != nil && $0?.accessToken != nil }
            .map { $0!.accessToken! }
            .flatMapLatest { [weak self] (accessToken) -> Driver<User> in
                guard let self = self else {return .empty()}
                
                return self.useCase.getUser(accessToken: accessToken)
            }
            .drive(onNext: { (user) in
                let sections: [MyProfileSection] = [.section(items: [.profile(user: user)]),
                                                      .section(items: [.repositories(user: user)]),
                                                      .section(items: [.stars(user: user)]),
                                                      .section(items: [.followers(user: user)]),
                                                      .section(items: [.following(user: user)])]
                sectionsReplay.accept(sections)
            })
            .disposed(by: disposeBag)
        input.selection
            .drive(onNext: { [weak self] (item) in
                guard let self = self else {return}
                
                let url: String?
                switch item {
                case .profile(let user):
                    url = user?.html_url
                case .repositories(let user):
                    url = user?.html_url.appending("?tab=repositories")
                case .stars(let user):
                    url = user?.html_url.appending("?tab=stars")
                case .followers(let user):
                    url = user?.html_url.appending("?tab=followers")
                case .following(let user):
                    url = user?.html_url.appending("?tab=following")
                }
                
                if let url = url {
                    self.navigator.presentPanModalWeb(url)
                }
            })
            .disposed(by: disposeBag)
        return Output(sections: Driver.combineLatest(input.theme, sectionsReplay.asDriverOnErrorJustNever()) { $1 })
    }
    
}
