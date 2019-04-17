//
//  AccessTokenRealmProxy.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import RealmWrapper

struct AccessTokenRealmProxy<RealmManager: AccessTokenRealmManager>: RealmProxiable {
    
    var accessToken: AccessToken? {
        return query().results.first
    }
    
    // MARK: - Internal methods
    
    func append(_ accessToken: AccessToken) {
        rm.transaction(writeHandler: { (realm) in
            realm.add(accessToken, update: true)
        })
    }
    
}
