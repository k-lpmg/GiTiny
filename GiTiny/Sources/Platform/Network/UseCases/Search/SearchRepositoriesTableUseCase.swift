//
//  SearchRepositoriesTableUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class SearchRepositoriesTableUseCase {
    
    private let provider = GiTinyProvider<GitHubSearchService>()
    
    func getRepositoriesResponse(query: String, sort: GitHubSearchService.RepositoriesSort, page: Int, perPage: Int) -> Driver<Response> {
        return provider.rx.request(.repositories(query: query, sort: sort, page: page, perPage: perPage)).asDriverOnErrorJustNever()
        
    }
    
}
