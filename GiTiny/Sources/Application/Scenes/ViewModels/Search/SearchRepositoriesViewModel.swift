//
//  SearchRepositoriesViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 17/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift

final class SearchRepositoriesViewModel {
    
    struct Request {
        let page: Int
        let query: String
        let sort: GitHubSearchService.RepositoriesSort
    }
    
    private let navigator: SearchNavigator
    private let useCase: SearchRepositoriesTableUseCase
    private var disposeBag = DisposeBag()
    
    init(navigator: SearchNavigator, useCase: SearchRepositoriesTableUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension SearchRepositoriesViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let request: Driver<Request>
        let perPage: Int
        let modelSelected: Driver<SearchRepository>
    }
    struct Output {
        let searchRepositories: Driver<[SearchRepository]>
        let apiRateLimit: Driver<GitHubAPIRateLimit>
    }
    
    func transform(input: Input) -> Output {
        let responseWithQueryAndSort: Driver<(Response, Request)> = input.request
            .flatMapLatest { [weak self] (request) in
                guard let self = self else {return .empty()}
                
                let query = request.query
                let sort = request.sort
                let page = request.page
                let response = self.useCase.getRepositoriesResponse(query: query, sort: sort, page: page, perPage: input.perPage)
                return response.map { ($0, request) }
        }
        
        let prevInfo: BehaviorRelay<([SearchRepository], Request)?> = .init(value: nil)
        let searchRepositories: PublishRelay<[SearchRepository]> = .init()
        responseWithQueryAndSort
            .drive(onNext: { (response, request) in
                let query = request.query
                let sort = request.sort
                
                guard let prevInfoValue = prevInfo.value, query == prevInfoValue.1.query, sort == prevInfoValue.1.sort else {
                    guard let repositoriesResponse = try? response.map(SearchRepositories.self).items else {return}
                    
                    searchRepositories.accept(repositoriesResponse)
                    prevInfo.accept((repositoriesResponse, request))
                    return
                }
                
                guard let repositoriesResponse = try? response.map(SearchRepositories.self).items else {return}
                
                var repositories = prevInfoValue.0
                repositories.append(contentsOf: repositoriesResponse)
                searchRepositories.accept(repositories)
                prevInfo.accept((repositories, request))
            })
            .disposed(by: disposeBag)
        let apiRateLimit = responseWithQueryAndSort
            .filter { (try? $0.0.map(GitHubAPIRateLimit.self)) != nil }
            .map { try! $0.0.map(GitHubAPIRateLimit.self) }
        
        input.modelSelected
            .drive(onNext: { [weak self] (searchRepository) in
                guard let self = self else {return}
                
                let url = searchRepository.html_url
                guard UserDefaults.standard.object(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository) != nil else {
                    self.navigator.presentPanModalWeb(url)
                    return
                }
                guard UserDefaults.standard.bool(forKey: UserDefaultsKey.kSetREADMEAsStartScreenOfRepository) else {
                    self.navigator.presentPanModalWeb(url)
                    return
                }
                self.navigator.presentPanModalWeb(url.appending("/blob/master/README.md"))
            })
            .disposed(by: disposeBag)
        return Output(searchRepositories: Driver.combineLatest(input.theme, searchRepositories.asDriverOnErrorJustNever()) { $1 },
                      apiRateLimit: apiRateLimit)
    }
    
}
