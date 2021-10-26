//
//  Playlist.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-12.
//

import Foundation

struct Playlist: Codable{
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
