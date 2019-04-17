//
//  TrendingRepositoriesTableViewModel.swift
//  GiTiny
//
//  Created by DongHeeKang on 06/01/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class TrendingRepositoriesTableViewModel {
    
    private let navigator: TrendingNavigator
    private let useCase: TrendingRepositoriesUseCase
    private var disposeBag = DisposeBag()
    
    init(navigator: TrendingNavigator, useCase: TrendingRepositoriesUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
}

// MARK: - ViewModelType

extension TrendingRepositoriesTableViewModel: ViewModelType {
    
    struct Input {
        let theme: Driver<Void>
        let serviceParameters: Driver<(String?, Since)>
        let modelSelected: Driver<TrendingRepository>
        let languageButtonClick: Driver<Void>
    }
    struct Output {
        let fetching: Driver<Bool>
        let repositories: Driver<[TrendingRepository]>
        let selectedLanguage: Driver<TrendingLanguage>
    }
    
    func transform(input: Input) -> Output {
        let fetching = PublishRelay<Bool>()
        let repositories: Driver<[TrendingRepository]> = input.serviceParameters
            .flatMapLatest { [weak self] in
                guard let self = self else {return .empty()}
                
                return self.useCase.getRepositories(language: $0, since: $1, fetching: fetching)
        }
        let selectedLanguage: PublishRelay<TrendingLanguage> = .init()
        
        input.modelSelected
            .drive(onNext: { [weak self] (repository) in
                guard let self = self else {return}
                
                let url = repository.url
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
        input.languageButtonClick
            .drive(onNext: { [weak self] (_) in
                guard let self = self else {return}
                self.navigator.presentLanguages()
                    .subscribe(onNext: { (language) in
                        
                        UserDefaults.standard.set(language.urlParam, forKey: UserDefaultsKey.kLastSearchLanguageUrlParamInTrendingRepositories)
                        UserDefaults.standard.set(language.name, forKey: UserDefaultsKey.kLastSearchLanguageNameInTrendingRepositories)
                        selectedLanguage.accept(language)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        return Output(fetching: fetching.asDriverOnErrorJustNever(),
                      repositories: Driver.combineLatest(input.theme, repositories) { $1 },
                      selectedLanguage: selectedLanguage.asDriverOnErrorJustNever())
    }
    
}
