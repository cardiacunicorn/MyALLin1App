//
//  WeatherAPIRequest.swift
//  MyALLin1
//
//  Created by Erin Carroll on 5/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import Foundation

protocol Refresh {
    func updateUI()
}

class WeatherAPIRequest {

    let session = URLSession.shared
    
    var delegate:Refresh?
    
    var weatherList:[Weather] = []

    // Specify URL components
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    let latitudeParameter = "lat="
    let longitudeParameter = "&lon="
    let units = "&units=metric"
    let appID = "&appid=24b6d30815f3ed441901aeac0187c790"

    func getWeather(longitude:String, latitude:String, isCurrentLocation:Bool, savedLocation:SavedLocation?){
        
        // Build URL for API call
        let stringURL = baseURL + latitudeParameter + latitude + longitudeParameter + longitude + units + appID
        
        if let url = URL(string: stringURL){
            let request = URLRequest(url: url)
            getData(request, isCurrentLocation: isCurrentLocation, savedLocation: savedLocation)
        }
    }
    
    func getData(_ request: URLRequest, isCurrentLocation:Bool, savedLocation:SavedLocation?){
        let task = session.dataTask(with: request, completionHandler: { data, response, downloadError in
            if let error = downloadError {
                print(error)
            }
            else {
                var parsedResult: Any! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                } catch { print() }
                
                let resultJson = parsedResult as! [String:Any]
                
                // Get location name
                if let locationName = resultJson["name"] as? String {
                
                    // Get temperature
                    let mainJson = resultJson["main"] as! [String:Any]
                    let temp = mainJson["temp"] as! Double
                    
                    // Get weather description
                    let weatherJson = resultJson["weather"] as! [[String:Any]]
                    let description = weatherJson.first!["main"] as! String
                    
                    if isCurrentLocation {
                    
                        // Create weather object
                        let weatherInfo = Weather(locationName: locationName, temp: Int(temp), description: description, isCurrentLocation: isCurrentLocation, savedLocation: nil)
                        
                        self.weatherList.append(weatherInfo)
                    } else {
                        // Create weather object
                        let weatherInfo = Weather(locationName: savedLocation!.name!, temp: Int(temp), description: description, isCurrentLocation: isCurrentLocation, savedLocation: savedLocation)
                        
                        self.weatherList.append(weatherInfo)
                    }

                }
            }
            
            DispatchQueue.main.async {
                self.delegate?.updateUI()
            }
        })
        task.resume()
    }
    static let shared = WeatherAPIRequest()
}
