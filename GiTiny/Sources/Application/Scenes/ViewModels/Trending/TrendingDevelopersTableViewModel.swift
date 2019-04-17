//
//  TrendingDevelopersTableViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 06/01/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class TrendingDevelopersTableViewModel {
    
    private let navigator: TrendingNavigator
    private let useCase: TrendingDevelopersUseCase
    private var disposeBag = DisposeBag()
    
    init(navigator: TrendingNavigator, useCase: TrendingDevelopersUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension TrendingDevelopersTableViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let request: Driver<(String?, Since)>
        let modelSelected: Driver<TrendingDeveloper>
        let languageButtonClick: Driver<Void>
    }
    struct Output {
        let fetching: Driver<Bool>
        let developers: Driver<[TrendingDeveloper]>
        let selectedLanguage: Driver<TrendingLanguage>
    }
    
    func transform(input: Input) -> Output {
        let fetching: PublishRelay<Bool> = .init()
        let developers: Driver<[TrendingDeveloper]> = input.request
            .flatMapLatest { [weak self] in
                guard let self = self else {return .empty()}
                
                return self.useCase.getDevelopers(language: $0.0, since: $0.1, fetching: fetching)
        }
        let selectedLanguage: PublishRelay<TrendingLanguage> = .init()
        
        input.modelSelected
            .drive(onNext: { [weak self] (developer) in
                guard let self = self else {return}
                
                self.navigator.presentPanModalWeb(developer.url)
            })
            .disposed(by: disposeBag)
        input.languageButtonClick
            .drive(onNext: { [weak self] (_) in
                guard let self = self else {return}
                self.navigator.presentLanguages()
                    .subscribe(onNext: { (language) in
                        
                        UserDefaults.standard.set(language.urlParam, forKey: UserDefaultsKey.kLastSearchLanguageUrlParamInTrendingDevelopers)
                        UserDefaults.standard.set(language.name, forKey: UserDefaultsKey.kLastSearchLanguageNameInTrendingDevelopers)
                        selectedLanguage.accept(language)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(fetching: fetching.asDriverOnErrorJustNever(),
                      developers: Driver.combineLatest(input.theme, developers) { $1 },
                      selectedLanguage: selectedLanguage.asDriverOnErrorJustNever())
    }
    
}
