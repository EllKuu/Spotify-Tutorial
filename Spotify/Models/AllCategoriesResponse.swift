//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by elliott kung on 2021-11-07.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable{
    let items: [Category]
}

struct Category: Codable{
    let id: String
    let name: String
    let icons: [APIImage]
}
