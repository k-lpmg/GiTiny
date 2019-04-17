//
//  GitHubService.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya

enum GitHubService {
    case user(username: String)
}

// MARK: - TargetType

extension GitHubService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .user(let username):
            return "users/\(username)"
        }
    }
    
    var method: Method {
        switch self {
        case .user:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .user:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        guard let accessToken = GitHubAccessManager.shared.accessTokenValue else {return nil}
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
}
