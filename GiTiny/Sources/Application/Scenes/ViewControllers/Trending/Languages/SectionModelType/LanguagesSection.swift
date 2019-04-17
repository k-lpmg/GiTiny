//
//  LanguagesSection.swift
//  GiTiny
//
//  Created by DongHeeKang on 23/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxDataSources

enum LanguagesSection {
    case section(title: String, items: [LanguageSectionItem])
}

extension LanguagesSection: SectionModelType {
    typealias Item = LanguageSectionItem
    
    var title: String {
        switch self {
        case .section(let title, _):
            return title
        }
    }
    
    var items: [Item] {
        switch  self {
        case .section(_, let items):
            return items.map {$0}
        }
    }
    
    init(original: LanguagesSection, items: [Item]) {
        switch original {
        case .section(let title, let items):
            self = .section(title: title, items: items)
        }
    }
}

enum LanguageSectionItem {
    case all(language: TrendingLanguage)
    case popular(language: TrendingLanguage)
    case other(language: TrendingLanguage)
}
