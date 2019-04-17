//
//  TrendingDevelopersUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class TrendingDevelopersUseCase {
    
    private let provider = MoyaProvider<TrendingService>()
    
    func getDevelopers(language: String?, since: Since?, fetching: PublishRelay<Bool>) -> Driver<[TrendingDeveloper]> {
        return self.provider.rx.request(.developers(language: language, since: since))
            .map([TrendingDeveloper].self)
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
