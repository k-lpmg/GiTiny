//
//  Int-Extensions.swift
//  GiTiny
//
//  Created by DongHeeKang on 29/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import Foundation

extension Int {
    var commaValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension Int64 {
    var commaValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension UInt64 {
    var commaValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
