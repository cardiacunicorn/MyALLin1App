//
//  DealsAPIRequest.swift
//  MyALLin1
//
//  Created by Chris Bowe on 17/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation

protocol RefreshDeals {
    func updateUI()
}

class DealAPIRequest {
    
    private let base_url = "https://api.sandbox.ebay.com/"
    private let client_id = "ChrisBow-MyALLin1-SBX-07aad0465-7eb61783"
    private let client_secret = "SBX-7aad0465b9d4-949d-4bcf-9922-e0dc"
    private var access_token = ""
    
    private let model = DealCategoryManager()
    private let session = URLSession.shared
    var task:URLSessionTask?
    
    var delegate:RefreshDeals?
    static let shared = DealAPIRequest()
    
    var dealList:[DealItem] = []
    
    // Get the oauth access token required for all api calls
    func getBearerToken() {
        let apiType = "identity/v1/oauth2/token?"
        let grantType = "client_credentials"
        let oauth = client_id + ":" + client_secret
        let oauthBase64 = oauth.data(using: String.Encoding.utf8)!.base64EncodedString()
        let scopes = "https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/buy.item.feed"
        let url = base_url + apiType + "grant_type=" + grantType + "&" + "scope=" + scopes
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

    // If no access token stored, get a new one
    func getBearerTokenData(_ request: URLRequest) {
        var result = [String:Any]()
        if access_token == "" {
            let semaphore = DispatchSemaphore(value: 0)
            task = session.dataTask(with: request, completionHandler: {
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
                    if result.count > 0 {
                        self.access_token = result["access_token"] as! String
                      }
                    semaphore.signal()
                }
            })
            task!.resume()
            semaphore.wait()
        }
    }
    
    func getCategoryItems(searchTerm: String) {
        let apiType = "buy/browse/v1/item_summary/search?"
        let itemParameter = "q="
        let encodingHeader = "application/gzip"
        let eBayMarketplaceId = "EBAY_AU"
        let url = base_url + apiType + itemParameter + searchTerm
        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        getBearerToken()
        if let url = URL(string: escapedAddress!) {
            var request = URLRequest(url: url)
            request.addValue("Bearer " + self.access_token, forHTTPHeaderField: "Authorization")
            request.addValue(encodingHeader, forHTTPHeaderField: "Accept-Encoding")
            request.addValue(eBayMarketplaceId, forHTTPHeaderField: "X-EBAY-C-MARKETPLACE-ID")
            request.httpMethod = "GET"
            getCategoryItemsData(request, searchTerm: searchTerm)
        }
    }
    
    func getCategoryItemsData(_ request: URLRequest, searchTerm: String){
        var result = [String:Any]()
        var totalItems = 0
        var itemSummaries = [[String:Any]]()
        
        task = session.dataTask(with: request, completionHandler: {
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
                totalItems = result["total"] as! Int
                if totalItems > 0 {
                    itemSummaries = result["itemSummaries"] as! [[String:Any]]
                    for dealItem in itemSummaries {
                        let category = searchTerm 
                        let title = dealItem["title"] as? String ?? ""
                        let price = dealItem["price"] as! [String:Any]
                        let value = price["value"] as? String ?? "0.00"
                        let currency = price["currency"] as? String ?? ""
                        let itemUrl = dealItem["itemWebUrl"] as? String ?? "https://www.ebay.com.au"
                        let image = dealItem["image"] as? [String:Any]
                        let imageUrl = image?["imageUrl"] as? String ?? ""
                        let dealItem = DealItem(category: category, title: title, value: value, currency: currency, itemUrl: itemUrl, imageUrl:imageUrl)
                        
                        self.dealList.append(dealItem)
                    }
                }
                else {
                    print("No items found for " + searchTerm)
                }
            }
            self.queueUpdate()
        })
        task!.resume()
    }
    
    func queueUpdate(){
        DispatchQueue.main.async {
            self.delegate?.updateUI()
        }
    }
}
