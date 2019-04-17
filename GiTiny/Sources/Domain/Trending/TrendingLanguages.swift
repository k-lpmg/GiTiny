//
//  TrendingLanguages.swift
//  GiTiny
//
//  Created by DongHeeKang on 25/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

struct TrendingLanguages: Decodable {
    let popular: [TrendingLanguage]
    let all: [TrendingLanguage]
}

struct TrendingLanguage {
    let urlParam: String
    let name: String
    
    init(urlParam: String, name: String) {
        self.urlParam = urlParam
        self.name = name
    }
    
    static var all: TrendingLanguage {
        return TrendingLanguage(urlParam: "", name: "All Languages".localized)
    }
}

extension TrendingLanguage: Decodable {
    
}

extension TrendingLanguage: Equatable {
    static func == (lhs: TrendingLanguage, rhs: TrendingLanguage) -> Bool {
        return lhs.urlParam == rhs.urlParam && lhs.name == rhs.name
    }
}
