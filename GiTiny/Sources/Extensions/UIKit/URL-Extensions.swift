//
//  URL-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import UIKit

extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {return nil}
        
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
