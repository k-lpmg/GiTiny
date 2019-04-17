//
//  Since.swift
//  GiTiny
//
//  Created by DongHeeKang on 29/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

enum Since: String, CaseIterable {
    case daily
    case weekly
    case monthly
    
    var upperTitle: String {
        switch self {
        case .daily:
            return "Today"
        case .weekly:
            return "This week"
        case .monthly:
            return "This month"
        }
    }
    
    var lowerTitle: String {
        switch self {
        case .daily:
            return "today"
        case .weekly:
            return "this week"
        case .monthly:
            return "this month"
        }
    }
}
