//
//  AppInfo.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Foundation

final class AppInfo {
    
    static let shared = AppInfo()
    
    // MARK: - Properties
    
    var infoDictionary: [String: Any] {
        return Bundle.main.infoDictionary!
    }
    
    var urlTypes: [NSDictionary] {
        return infoDictionary[AppInfoKey.CFBundleURLTypes] as! [NSDictionary]
    }
    
}
