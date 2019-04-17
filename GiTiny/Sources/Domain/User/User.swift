//
//  User.swift
//  GiTiny
//
//  Created by DongHeeKang on 20/02/2019.
//  Copyright © 2019 k-lpmg. All rights reserved.
//

struct User: Decodable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String?
    let gravatar_id: String?
    let html_url: String
    let name: String?
    let company: String?
    let blog: String?
    let email: String?
    let location: String?
    let bio: String?
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
    let private_gists: Int?
    let total_private_repos: Int?
    let owned_private_repos: Int?
}
