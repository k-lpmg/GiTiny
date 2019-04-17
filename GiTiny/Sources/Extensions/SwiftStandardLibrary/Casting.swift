//
//  Casting.swift
//  GiTiny
//
//  Created by DongHeeKang on 25/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

extension Int {
    var doubleValue: Double {return Double(self)}
    var stringValue: String {return String(self)}
}

extension Int32 {
    var doubleValue: Double {return Double(self)}
}

extension Int64 {
    var doubleValue: Double {return Double(self)}
    var stringValue: String {return String(self)}
}

extension UInt64 {
    var doubleValue: Double {return Double(self)}
    var stringValue: String {return String(self)}
}

extension Double {
    var intValue: Int {return Int(self)}
    var stringValue: String {return String(self)}
}

extension Float {
    var doubleValue: Double {return Double(self)}
    var intValue: Int {return Int(self)}
}

extension String {
    var doubleValue: Double {return Double(self) ?? 0.0}
    var intValue: Int? {return Int(self)}
    var int64Value: Int64? {return Int64(self)}
    var uInt64Value: UInt64? {return UInt64(self)}
}
