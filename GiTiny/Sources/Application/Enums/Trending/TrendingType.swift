//
//  TrendingType.swift
//  GiTiny
//
//  Created by DongHeeKang on 01/01/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

enum TrendingType: Int, CaseIterable {
    case repositories
    case developers
    
    var title: String {
        switch self {
        case .repositories:
            return "Repositories"
        case .developers:
            return "Developers"
        }
    }
    
    var description: String {
        switch self {
        case .repositories:
            return "See what the GitHub community is most excited about"
        case .developers:
            return "These are the organizations and developers building the hot tools"
        }
    }
}
