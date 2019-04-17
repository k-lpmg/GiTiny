//
//  SearchUsers.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/03/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

struct SearchUsers: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [SearchUser]
}

struct SearchUser: Decodable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let repos_url: String
}
