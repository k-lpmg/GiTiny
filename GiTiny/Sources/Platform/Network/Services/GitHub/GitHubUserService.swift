//
//  GitHubUserService.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya

enum GitHubUserService {
    case getMe(accessToken: String)
    
    case getStarred(accessToken: String, owner: String, repo: String)
    case putStarred(accessToken: String, owner: String, repo: String)
    case deleteStarred(accessToken: String, owner: String, repo: String)
    
    case getFollowing(accessToken: String, username: String)
    case putFollowing(accessToken: String, username: String)
    case deleteFollowing(accessToken: String, username: String)
}

// MARK: - TargetType

extension GitHubUserService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com/user")!
    }
    
    var path: String {
        switch self {
        case .getMe:
            return ""
        case .getStarred(_, let owner, let repo), .putStarred(_, let owner, let repo), .deleteStarred(_, let owner, let repo):
            return "/starred" + "/" + owner + "/" + repo
        case .getFollowing(_, let username), .putFollowing(_, let username), .deleteFollowing(_, let username):
            return "/following" + "/" + username
        }
    }
    
    var method: Method {
        switch self {
        case .getMe, .getStarred, .getFollowing:
            return .get
        case .putStarred, .putFollowing:
            return .put
        case .deleteStarred, .deleteFollowing:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        let token: String
        switch self {
        case .getMe(let accessToken),
             .getStarred(let accessToken, _, _),
             .putStarred(let accessToken, _, _),
             .deleteStarred(let accessToken, _, _),
             .getFollowing(let accessToken, _),
             .putFollowing(let accessToken, _),
             .deleteFollowing(let accessToken, _):
            token = accessToken
        }
        return ["Authorization": "Bearer \(token)"]
    }
    
}
