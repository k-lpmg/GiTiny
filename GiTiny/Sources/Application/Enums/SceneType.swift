//
//  SceneType.swift
//  GiTiny
//
//  Created by DongHeeKang on 30/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

enum SceneType: String {
    case trending
    case search
    case myProfile
    case setting
    
    var tabBarItem: UITabBarItem {
        let tabBarItem = UITabBarItem(title: nil, image: UIImage(named: rawValue), selectedImage: nil)
        let padding: CGFloat = 4
        tabBarItem.imageInsets = UIEdgeInsets(top: padding, left: 0, bottom: -padding, right: 0)
        return tabBarItem
    }
}
