//
//  UserLoginUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class UserLoginUseCase {
    
    private let provider = GiTinyProvider<GitHubLoginService>()
    
    func getAccessToken(code: String) -> Driver<AccessToken> {
        return provider.request(AccessToken.self, token: .login(code: code))
            .asObservable()
            .asDriverOnErrorJustNever()
    }
    
}
