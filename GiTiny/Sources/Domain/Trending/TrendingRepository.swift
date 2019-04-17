//
//  TrendingRepository.swift
//  GiTiny
//
//  Created by DongHeeKang on 25/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

struct TrendingRepository: Decodable {
    let author: String
    let name: String
    let url: String
    let description: String
    let language: String?
    let languageColor: String?
    let stars: Int
    let forks: Int
    let currentPeriodStars: Int
}
