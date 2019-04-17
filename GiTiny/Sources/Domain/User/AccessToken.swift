//
//  AccessToken.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers
final class AccessToken: Object, Decodable {
    
    // MARK: - Constants
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
    
    // MARK: - Properties
    
    dynamic var accessToken: String?
    dynamic var scope: String?
    dynamic var tokenType: String?
    
    @objc private dynamic var primaryKey: String?
    
    // MARK: - Con(De)structor
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        scope = try container.decode(String.self, forKey: .scope)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        primaryKey = Bundle.main.bundleIdentifier
    }
    
    // MARK: - Overridden: Object
    
    override static func primaryKey() -> String? {
        return "primaryKey"
    }
    
}
