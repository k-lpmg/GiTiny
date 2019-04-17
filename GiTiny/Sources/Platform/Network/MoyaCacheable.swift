//
//  MoyaCacheable.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Foundation

protocol MoyaCacheable {
    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}
