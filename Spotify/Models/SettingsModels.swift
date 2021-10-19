//
//  SettingsModels.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-18.
//

import Foundation

struct Section{
    let title: String
    let options: [Option]
}

struct Option{
    let title: String
    let handler: () -> Void
}
