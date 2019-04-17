//
//  AppTheme.swift
//  GiTiny
//
//  Created by DongHeeKang on 21/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

enum AppTheme: Int {
    case day
    case night
}

extension AppTheme {
    
    var backgroundColor: UIColor {
        switch self {
        case .day:
            return .white
        case .night:
            return .lightBlack2
        }
    }
    
    var fluidNormalColor1: UIColor {
        switch self {
        case .day:
            return .white
        case .night:
            return .lightBlack2
        }
    }
    
    var fluidNormalColor2: UIColor {
        switch self {
        case .day:
            return .white
        case .night:
            return .lightBlack3
        }
    }
    
    var fluidHighlightColor: UIColor {
        switch self {
        case .day:
            return UIColor.lightGray.withAlphaComponent(0.2)
        case .night:
            return UIColor.lightBlack3.withAlphaComponent(0.2)
        }
    }
    
    var subviewBackgroundColor: UIColor {
        switch self {
        case .day:
            return .lightGray1
        case .night:
            return .lightBlack3
        }
    }
    
    var tableViewBackgroundColor: UIColor {
        switch self {
        case .day:
            return .lightGray1
        case .night:
            return .lightBlack2
        }
    }
    
    var tableViewSeparatorColor: UIColor {
        switch self {
        case .day:
            return .lightGray2
        case .night:
            return .darkGray
        }
    }
    
    var cellBackgroundColor: UIColor {
        switch self {
        case .day:
            return .white
        case .night:
            return .lightBlack3
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .day:
            return .black
        case .night:
            return .white
        }
    }
    
    var imageTintColor: UIColor {
        switch self {
        case .day:
            return .black
        case .night:
            return .lightGray
        }
    }
    
    var tabBarTintColor: UIColor {
        switch self {
        case .day:
            return .black
        case .night:
            return UIColor.lightBlack1
        }
    }
    
    var navigationBarTintColor: UIColor {
        switch self {
        case .day:
            return .white
        case .night:
            return UIColor.lightBlack1
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .day:
            return .default
        case .night:
            return .lightContent
        }
    }
    
    var textColor: UIColor {
        return tintColor
    }
    
    var systemDefaultTextColor: UIColor {
        switch self {
        case .day:
            return UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        case .night:
            return .white
        }
    }
    
    var lineColor: UIColor {
        switch self {
        case .day:
            return UIColor(white: 0.95, alpha: 1.0)
        case .night:
            return UIColor(white: 0.3, alpha: 1.0)
        }
    }
    
}
