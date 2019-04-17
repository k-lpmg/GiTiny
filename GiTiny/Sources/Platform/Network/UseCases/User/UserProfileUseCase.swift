//
//  UserProfileUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class UserProfileUseCase {
    
    private let provider = MoyaProvider<GitHubUserService>()
    
    func getUser(accessToken: String) -> Driver<User> {
        return provider.rx.request(.getMe(accessToken: accessToken))
            .map(User.self)
            .asObservable()
            .asDriverOnErrorJustNever()
    }
    
}
