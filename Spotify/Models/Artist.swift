//
//  Artist.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-12.
//

import Foundation

struct Artist: Codable{
    let id: String
    let name: String
    let type: String
    let external_urls: [String : String]
}
