//
//  NewsAPIRequest.swift
//  MyALLin1
//
//  Created by Erin Carroll on 18/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation

// Protocol for reloading UI in view controller
protocol RefreshNews {
    func updateUI()
}

class NewsAPIRequest {

    let session = URLSession.shared
    
    var delegate:RefreshNews?
    
    var newsList:[NewsItem] = []

    // Specify URL components
    let baseURL = "https://newsapi.org/v2/top-headlines"
    let query = "?category="
    let key = "&apiKey=18b4ede6cafe4104acdda3d8d8caa97b"
    
    func getNews(category: String){
        
        newsList = []
        
        // Build URL for API call
        let stringURL = baseURL + query + category + key
        
        if let url = URL(string: stringURL){
            let request = URLRequest(url: url)
            getData(request)
        }
    }
    
    func getData(_ request: URLRequest){
        let task = session.dataTask(with: request, completionHandler: { data, response, downloadError in
            if let error = downloadError {
                print(error)
            }
            else {
                // Parse JSON response from the API
                var parsedResult: Any! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                } catch { print() }
                
                let result = parsedResult as! [String:Any]
                
                let articles = result["articles"] as! [[String:Any]]
                
                if articles.count > 0 {
                
                    for article in articles {
                        // Get title, image URL, content description, and article URL
                        let title = article["title"] as! String
                        let imageURLValue = article["urlToImage"] as? String
                        let contentValue = article["content"] as? String
                        let url = article["url"] as! String
                        
                        // Detect article dominant language
                        // Only create objects for articles in English
                        if let language = NSLinguisticTagger.dominantLanguage(for: title) {
                            if language == "en" {
                                // Handle cases where image URL and/or content
                                // description are null and create news object
                                if let content = contentValue {
                                    if let imageURL = imageURLValue {
                                        let newsItem = NewsItem(title: title, imageURL: imageURL, content: content, url: url)
                                        self.newsList.append(newsItem)
                                    } else {
                                        let newsItem = NewsItem(title: title, imageURL: nil, content: content, url: url)
                                        self.newsList.append(newsItem)
                                    }
                                } else {
                                    if let imageURL = imageURLValue {
                                        let newsItem = NewsItem(title: title, imageURL: imageURL, content: nil, url: url)
                                        self.newsList.append(newsItem)
                                    }
                                    else {
                                        let newsItem = NewsItem(title: title, imageURL: nil, content: nil, url: url)
                                        self.newsList.append(newsItem)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // Update UI in view controller once response has been received and processed
            DispatchQueue.main.async {
                self.delegate?.updateUI()
            }
        })
        task.resume()
    }
    
    static let shared = NewsAPIRequest()
}
