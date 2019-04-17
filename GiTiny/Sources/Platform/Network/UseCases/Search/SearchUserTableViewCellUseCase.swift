//
//  SearchUserTableViewCellUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class SearchUserTableViewCellUseCase {
    
    private let provider = MoyaProvider<GitHubService>()
    
    func getUser(username: String) -> Driver<User> {
        return provider.rx.request(.user(username: username))
            .map(User.self)
            .asDriverOnErrorJustNever()
    }
    
}
