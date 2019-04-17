//
//  TrendingDeveloper.swift
//  GiTiny
//
//  Created by DongHeeKang on 25/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

struct TrendingDeveloper: Decodable {
    let username: String
    let name: String?
    let url: String
    let avatar: String
    let repo: TrendingDeveloperRepository
}

struct TrendingDeveloperRepository: Decodable {
    let name: String
    let description: String
    let url: String
}
