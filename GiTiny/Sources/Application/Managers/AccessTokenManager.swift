//
//  GitHubAccessManager.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa
import RxSwift

final class GitHubAccessManager {
    
    static let shared = GitHubAccessManager()
    
    class var clientID: String {
        guard let id = shared.info?["clientID"] else {fatalError()}
        return id
    }
    
    class var clientSecret: String {
        guard let secret = shared.info?["clientSecret"] else {fatalError()}
        return secret
    }
    
    class var callBackURLSchemes: String {
        guard let schemes = AppInfo.shared.urlTypes.first?[AppInfoKey.CFBundleURLSchemes] as? [String] else {fatalError()}
        return schemes.first!
    }
    
    class func removeAccessToken() {
        shared.accessToken.accept(nil)
    }
    
    // MARK: - Con(De)structor
    
    init() {
        accessToken
            .subscribe(onNext: { (accessToken) in
                guard let accessToken = accessToken else {return}
                AccessTokenRealmProxy().append(accessToken)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Properties
    
    let accessToken: BehaviorRelay<AccessToken?> = .init(value: AccessTokenRealmProxy().accessToken)
    var accessTokenValue: String? {
        return accessToken.value?.accessToken
    }
    
    private var info: [String: String]? = {
        guard let path = Bundle.main.path(forResource: "GiTiny-Info", ofType: "plist"),
        let info = NSDictionary(contentsOfFile: path) as? [String: String] else {return nil}
        return info
    }()
    private var disposeBag = DisposeBag()
    
}
