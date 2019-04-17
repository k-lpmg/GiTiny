//
//  TrendingService.swift
//  GiTiny
//
//  Created by DongHeeKang on 27/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import Moya

enum TrendingService {
    case repositories(language: String?, since: Since?)
    case developers(language: String?, since: Since?)
    case languages
}

// MARK: - TargetType

extension TrendingService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://github-trending-api.now.sh/")!
    }
    
    var path: String {
        switch self {
        case .repositories:
            return "repositories"
        case .developers:
            return "developers"
        case .languages:
            return "languages"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .repositories(let language, let since):
            var parameters = [String: Any]()
            if let language = language {
                parameters["language"] = language
            }
            if let since = since {
                parameters["since"] = since.rawValue
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .developers(let language, let since):
            var parameters = [String: Any]()
            if let language = language {
                parameters["language"] = language
            }
            if let since = since {
                parameters["since"] = since.rawValue
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .languages:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
    
}
