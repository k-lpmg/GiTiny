//
//  SettingSection.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxDataSources

enum SettingSection {
    case section(items: [SettingSectionItem])
}

extension SettingSection: SectionModelType {
    typealias Item = SettingSectionItem
    
    var title: String {
        return ""
    }
    
    var items: [Item] {
        switch  self {
        case .section(let items):
            return items
        }
    }
    
    init(original: SettingSection, items: [Item]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
}

enum SettingSectionItem {
    case darkTheme
    case setREADME
    case giTinyRepo
    case openSourceLicenses
    case logout
}
