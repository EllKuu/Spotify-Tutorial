//
//  SearchResult.swift
//  Spotify
//
//  Created by elliott kung on 2021-11-08.
//

import Foundation

enum SearchResult{
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
