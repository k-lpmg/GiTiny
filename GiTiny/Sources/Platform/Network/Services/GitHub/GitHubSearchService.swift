//
//  GitHubSearchService.swift
//  GiTiny
//
//  Created by DongHeeKang on 22/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

import Moya

enum GitHubSearchService {
    enum RepositoriesSort: String, CaseIterable {
        case bestMatch = ""
        case stars
        case forks
        case updated
        
        var title: String {
            switch self {
            case .bestMatch:
                return "Best match"
            case .stars:
                return "Most stars"
            case .forks:
                return "Most forks"
            case .updated:
                return "Recently updated"
            }
        }
    }
    enum UsersSort: String, CaseIterable {
        case bestMatch = ""
        case followers
        case joined
        case repositories
        
        var title: String {
            switch self {
            case .bestMatch:
                return "Best match"
            case .followers:
                return "Most followers"
            case .joined:
                return "Most recently joined"
            case .repositories:
                return "Most repositories"
            }
        }
    }
    
    case userDetail(username: String)
    case users(query: String, sort: UsersSort?, page: Int, perPage: Int)
    case repositories(query: String, sort: RepositoriesSort?, page: Int, perPage: Int)
}

// MARK: - TargetType

extension GitHubSearchService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .userDetail(let username):
            return "users/" + username
        case .users:
            return "search/users"
        case .repositories:
            return "search/repositories"
        }
    }
    
    var method: Method {
        switch self {
        case .userDetail, .users, .repositories:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .users(let query, let sort, let page, let perPage):
            var parameters = [String: Any]()
            parameters["q"] = query
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            parameters["page"] = page
            parameters["per_page"] = perPage
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .repositories(let query, let sort, let page, let perPage):
            var parameters = [String: Any]()
            parameters["q"] = query
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            parameters["page"] = page
            parameters["per_page"] = perPage
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        guard let accessToken = GitHubAccessManager.shared.accessTokenValue else {return nil}
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
}
