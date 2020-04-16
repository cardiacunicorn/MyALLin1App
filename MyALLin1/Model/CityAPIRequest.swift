//
//  CityAPIRequest.swift
//  MyALLin1
//
//  Created by Erin Carroll on 8/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation

protocol RefreshResults {
    func updateUI()
}

class CityAPIRequest {
    
    let session = URLSession.shared
    
    var delegate:RefreshResults?
    
    var searchResults:[City] = []
    
    var task:URLSessionTask?

    func getCities(searchTerm: String) {
        
        // Ensure any existing search items are cleared
        searchResults = []
        
        // Build URL for API call
        let baseURL = "http://geodb-free-service.wirefreethought.com/v1/geo/cities?namePrefix="
        
        let stringURL = baseURL + searchTerm
        
        guard let escapedAddress = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        if let url = URL(string: escapedAddress){
            let request = URLRequest(url: url)
            getData(request)
        }
    }

    func getData(_ request: URLRequest){
        task = session.dataTask(with: request, completionHandler: { data, response, downloadError in
            if let error = downloadError {
                print(error)
            }
            else {
                var parsedResult: Any! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                } catch { print() }
                
                let result = parsedResult as! [String:Any]
                
                let data = result["data"] as! [[String:Any]]
                
                for city in data {
                    let cityName = city["city"] as! String
                    let country = city["country"] as! String
                    let longitude = city["longitude"] as! Double
                    let latitude = city["latitude"] as! Double

                    let city = City(name: cityName, country: country, longitude: longitude, latitude: latitude)
                    
                    self.searchResults.append(city)
                }
                
            }
            
            DispatchQueue.main.async {
                self.delegate?.updateUI()
            }
            
        })
        task!.resume()
    }
    
    static let shared = CityAPIRequest()

}
