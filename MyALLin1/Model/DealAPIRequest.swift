//
//  DealsAPIRequest.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation

struct DealAPIRequest{
    
    private let model = DealCategoryManager.sharedInstance
    private let session = URLSession.shared
    private let base_url = "https://api.sandbox.ebay.com/"
    private let client_id = "ChrisBow-MyALLin1-SBX-07aad0465-7eb61783"
    private let client_secret = "SBX-7aad0465b9d4-949d-4bcf-9922-e0dc"
    private var access_token = [String:Any]()
    var task:URLSessionTask?
    
    mutating func getBearerToken() {

        let apiType = "identity/v1/oauth2/token"
        let grantType = "client_credentials"
        let oauth = client_id + ":" + client_secret
        let oauthBase64 = oauth.data(using: String.Encoding.utf8)!.base64EncodedString()
        
        let scopes = "https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/buy.item.feed"
        let scopesEncoded = scopes.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = base_url + apiType + "?" + "grant_type=" + grantType //+ "&" + "scope=" + scopes
        let contentTypeHeader = "application/x-www-form-urlencoded"
        let authHeader = "Basic " + oauthBase64
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if let url = URL(string: escapedAddress!) {

            var request = URLRequest(url: url)
            request.addValue(contentTypeHeader, forHTTPHeaderField: "Content-Type")
            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            getBearerTokenData(request)
        }
    }

    func getBearerTokenData(_ request: URLRequest) {
        var result = [String:Any]()
        
        let task = session.dataTask(with: request, completionHandler: {
            data, response, downloadError in
            
            if let error = downloadError {
                print(error)
            }
        
            else {
                var parsedResult: Any! = nil
                do{
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch{print()}
                
                result = parsedResult as! [String:Any]
                print (result)
            }
        })
        task.resume()
    }
}
