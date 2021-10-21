//
//  AuthManager.swift
//  Spotify
//
//  Created by elliott kung on 2021-10-12.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    private init(){}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMin: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ){
        // get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
       // creating the request for a token
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            print("failure to get base 64")
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do{
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("SUCCESS \(json)")
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    /// supplies valid token to be used with API calls
    public func withValidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            // append the completion
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken{
            // refresh
            refreshAccessTokenIfNeeded { [weak self]success in
                    if let token = self?.accessToken, success{
                        completion(token)
                    }
            }
        }
        else if let token = accessToken{
            completion(token)
        }
        
    }
    
    public func refreshAccessTokenIfNeeded(completion: ((Bool) -> Void)?){
       
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        
        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
       // creating the request for a token
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion?(false)
            print("failure to get base 64")
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            do{
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{ $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                print("succesfully refreshed")
                self?.cacheToken(result: result)
                completion?(true)
            }catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
        
        

    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}
