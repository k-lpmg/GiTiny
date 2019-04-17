//
//  TrendingLanguagesViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 16/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class TrendingLanguagesViewModel {

    private let useCase: TrendingLanguagesUseCase
    
    init(useCase: TrendingLanguagesUseCase) {
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension TrendingLanguagesViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let items: Driver<[LanguagesSection]>
    }
    
    func transform(input: Input) -> Output {
        let items: Driver<[LanguagesSection]> = input.trigger
            .flatMapLatest { [weak self] in
                guard let self = self else {return .empty()}
                
                return self.useCase.getTrendingLanguages()
        }
        return Output(items: items)
    }
    
}
