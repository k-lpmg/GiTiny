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
    
    private let provider = GiTinyProvider<TrendingService>()
    
    func getDevelopers(language: String?, since: Since?, fetching: PublishRelay<Bool>) -> Driver<[TrendingDeveloper]> {
        return provider.request([TrendingDeveloper].self, token: .developers(language: language, since: since))
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
