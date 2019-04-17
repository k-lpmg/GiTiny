//
//  MyProfileLoginViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import SafariServices

import Moya
import RxCocoa
import RxSwift

final class MyProfileLoginViewModel {
    
    private let navigator: MyProfileNavigator
    private let useCase: UserLoginUseCase
    private var disposeBag = DisposeBag()
    private var authSession: SFAuthenticationSession?
    
    init(navigator: MyProfileNavigator, useCase: UserLoginUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    // MARK: - Private methods
    
    private func getLoginUrl() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"
        let clientIDQuery = URLQueryItem(name: "client_id", value: GitHubAccessManager.clientID)
        let scopeQuery = URLQueryItem(name: "scope", value: "user+repo+notifications")
        urlComponents.queryItems = [clientIDQuery, scopeQuery]
        return urlComponents.url!
    }
    
}

// MARK: - ViewModelType

extension MyProfileLoginViewModel: ViewModelType {
    
    struct Input {
        let authTrigger: Driver<Void>
    }
    struct Output {
        let accessToken: Driver<AccessToken>
    }
    
    func transform(input: Input) -> Output {
        let code: Driver<String> = input.authTrigger.flatMapLatest({ [weak self] (_) -> Driver<String> in
            guard let self = self else {return Driver<String>.empty()}
            
            let code = Single<String>.create { [weak self] (observer) -> Disposable in
                guard let self = self else {return Disposables.create()}
                
                self.authSession = SFAuthenticationSession(url: self.getLoginUrl(),
                                                           callbackURLScheme: GitHubAccessManager.callBackURLSchemes,
                                                           completionHandler: { (url, error) in
                                                            guard error == nil, let url = url, let code = url.queryParameters?["code"] else {
                                                                observer(.error(error!))
                                                                return
                                                            }
                                                            
                                                            observer(.success(code))
                })
                self.authSession?.start()
                
                return Disposables.create()
                }
                .asObservable()
                .asDriverOnErrorJustNever()
            return code
        })
        let accessToken: Driver<AccessToken> = code
            .flatMapLatest { [weak self] in
                guard let self = self else {return Driver<AccessToken>.empty()}
                
                return self.useCase.getAccessToken(code: $0)
        }
        return Output(accessToken: accessToken)
    }
    
}
