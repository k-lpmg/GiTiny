//
//  SearchUsersViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift

final class SearchUsersViewModel {
    
    struct Request {
        let page: Int
        let query: String
        let sort: GitHubSearchService.UsersSort
    }
    
    private let navigator: SearchNavigator
    private let useCase: SearchUsersTableUseCase
    private var disposeBag = DisposeBag()
    
    init(navigator: SearchNavigator, useCase: SearchUsersTableUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
}

 // MARK: - ViewModelType

extension SearchUsersViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let request: Driver<Request>
        let perPage: Int
        let modelSelected: Driver<SearchUser>
    }
    struct Output {
        let searchUsers: Driver<[SearchUser]>
        let apiRateLimit: Driver<GitHubAPIRateLimit>
    }
    
    func transform(input: Input) -> Output {
        let responseWithQuery: Driver<(Response, Request)> = input.request
            .flatMapLatest { [weak self] (request) in
                guard let self = self else {return .empty()}
                
                let query = request.query
                let sort = request.sort
                let page = request.page
                let response = self.useCase.getUsersResponse(query: query, sort: sort, page: page, perPage: input.perPage)
                return response.map { ($0, request) }
        }
        
        let prevInfo: BehaviorRelay<([SearchUser], Request)?> = .init(value: nil)
        let searchUsers: PublishRelay<[SearchUser]> = .init()
        responseWithQuery
            .drive(onNext: { (response, request) in
                let query = request.query
                let sort = request.sort
                
                guard let prevInfoValue = prevInfo.value, query == prevInfoValue.1.query, sort == prevInfoValue.1.sort else {
                    guard let usersResponse = try? response.map(SearchUsers.self).items else {return}
                    
                    searchUsers.accept(usersResponse)
                    prevInfo.accept((usersResponse, request))
                    return
                }
                
                guard let usersResponse = try? response.map(SearchUsers.self).items else {return}
                
                var users = prevInfoValue.0
                users.append(contentsOf: usersResponse)
                searchUsers.accept(users)
                prevInfo.accept((users, request))
            })
            .disposed(by: disposeBag)
        let apiRateLimit = responseWithQuery
            .filter { (try? $0.0.map(GitHubAPIRateLimit.self)) != nil }
            .map { try! $0.0.map(GitHubAPIRateLimit.self) }
        
        input.modelSelected
            .drive(onNext: { [weak self] (searchUser) in
                guard let self = self else {return}
                
                self.navigator.presentPanModalWeb(searchUser.html_url)
            })
            .disposed(by: disposeBag)
        return Output(searchUsers: Driver.combineLatest(input.theme, searchUsers.asDriverOnErrorJustNever()) { $1 },
                      apiRateLimit: apiRateLimit)
    }
    
}
