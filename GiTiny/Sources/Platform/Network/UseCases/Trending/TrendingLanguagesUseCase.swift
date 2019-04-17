//
//  TrendingLanguagesUseCase.swift
//  GiTiny
//
//  Created by DongHeeKang on 26/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya
import RxCocoa

final class TrendingLanguagesUseCase {
    
    private let provider = MoyaProvider<TrendingService>()
    
    func getTrendingLanguages() -> Driver<[LanguagesSection]> {
        return provider.rx.request(.languages)
            .map(TrendingLanguages.self)
            .map({ (response) -> [LanguagesSection] in
                var popularItems = [LanguageSectionItem]()
                response.popular.forEach { language in
                    popularItems.append(.popular(language: language))
                }
                var otherItems = [LanguageSectionItem]()
                response.all.forEach { language in
                    otherItems.append(.other(language: language))
                }
                return [.section(title: "All".localized, items: [.all(language: TrendingLanguage.all)]),
                        .section(title: "Popular".localized, items: popularItems),
                        .section(title: "Other".localized, items: otherItems)]
            })
            .asObservable()
            .asDriverOnErrorJustNever()
    }
    
}
