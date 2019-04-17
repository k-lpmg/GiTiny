//
//  MyProfileSection.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RxDataSources

enum MyProfileSection {
    case section(items: [UserProfileSectionItem])
}

extension MyProfileSection: SectionModelType {
    typealias Item = UserProfileSectionItem
    
    var title: String {
        return ""
    }
    
    var items: [Item] {
        switch  self {
        case .section(let items):
            return items
        }
    }
    
    init(original: MyProfileSection, items: [Item]) {
        switch original {
        case .section(let items):
            self = .section(items: items)
        }
    }
}

enum UserProfileSectionItem {
    case profile(user: User?)
    case repositories(user: User?)
    case stars(user: User?)
    case followers(user: User?)
    case following(user: User?)
    
    var title: String {
        switch self {
        case .profile:
            return "Profile"
        case .repositories:
            return "Repositories"
        case .stars:
            return "Stars"
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}
