//
//  SearchUsersTableUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class SearchUsersTableUseCase {
    
    private let provider = GiTinyProvider<GitHubSearchService>()
    
    func getUsersResponse(query: String, sort: GitHubSearchService.UsersSort, page: Int, perPage: Int) -> Driver<Response> {
        return provider.rx.request(.users(query: query, sort: sort, page: page, perPage: perPage)).asDriverOnErrorJustNever()
    }
    
}
