//
//  AuthManager.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-12.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    struct Constants{
        static let clientID = "3b8a6613d348457ea3ca779d37e83136"
        static let clientSecret =  "2ba2e20370e943799f875783f03e4946"
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    private init(){}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String?{
        return nil
    }
    
    private var refreshToken: String?{
        return nil
    }
    
    private var tokenExpirationDate: Date?{
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ){
        // get token
        
    }
    
    public func refreshAccessToken(){
        
    }
    
    private func cacheToken(){
        
    }
    
}
