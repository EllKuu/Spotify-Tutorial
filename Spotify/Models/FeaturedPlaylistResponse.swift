//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-26.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable{
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable{
    let items: [Playlist]
}


struct User: Codable{
    let display_name: String
    let external_urls: [String: String]
    let id: String
}