//
//  SearchViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxCocoa
import RxSwift

final class SearchViewModel {
    
    private let navigator: SearchNavigator
    private var disposeBag = DisposeBag()
    
    init(navigator: SearchNavigator) {
        self.navigator = navigator
    }
    
}

// MARK: - ViewModelType

extension SearchViewModel: ViewModelType {
    
    struct Input {
        let searchText: Driver<String?>
        let repositoriesSeeMore: Driver<Void>
        let usersSeeMore: Driver<Void>
    }
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        input.repositoriesSeeMore
            .withLatestFrom(input.searchText)
            .drive(onNext: navigator.pushRepositories)
            .disposed(by: disposeBag)
        input.usersSeeMore
            .withLatestFrom(input.searchText)
            .drive(onNext: navigator.pushUsers)
            .disposed(by: disposeBag)
        return Output()
    }
    
}
