//
//  GitHubLoginService.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya

enum GitHubLoginService {
    case login(code: String)
}

// MARK: - TargetType

extension GitHubLoginService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://github.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login/oauth/access_token"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .login(let code):
            var parameters = [String: Any]()
            parameters["client_id"] = GitHubAccessManager.clientID
            parameters["client_secret"] = GitHubAccessManager.clientSecret
            parameters["code"] = code
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login:
            return ["Accept": "application/json"]
        }
    }
    
}
