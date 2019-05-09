//
//  TrendingRepositoriesUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class TrendingRepositoriesUseCase {
    
    private let provider = GiTinyProvider<TrendingService>()
    
    func getRepositories(language: String?, since: Since?, fetching: PublishRelay<Bool>) -> Driver<[TrendingRepository]> {
        return provider.request([TrendingRepository].self, token: .repositories(language: language, since: since))
            .do(onSuccess: { (_) in
                fetching.accept(false)
            }, onError: { (_) in
                fetching.accept(false)
            }, onSubscribe: {
                fetching.accept(true)
            })
            .asDriver(onErrorJustReturn: [])
    }
    
}
