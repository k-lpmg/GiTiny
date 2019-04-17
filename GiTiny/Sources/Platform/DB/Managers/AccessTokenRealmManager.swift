//
//  AccessTokenRealmManager.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RealmSwift
import RealmWrapper

final class AccessTokenRealmManager: RealmManageable {
    
    var isUseInMemory: Bool {
        return false
    }
    
    var schemaVersion: UInt64 {
        return 1
    }
    
    var appGroupIdentifier: String? {
        return APP_GROUP_ID
    }
    
    var fileName: String {
        return "accessToken"
    }
    
    var objectTypes: [Object.Type]? {
        return [AccessToken.self]
    }
    
}
