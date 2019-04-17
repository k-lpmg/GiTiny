//
//  String-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import Foundation

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
