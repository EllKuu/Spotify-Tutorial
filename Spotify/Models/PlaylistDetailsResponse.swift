//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by elliott kung on 2021-11-05.
//

import Foundation

struct PlaylistDetailsResponse: Codable{
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable{
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable{
    let track: AudioTrack
}
