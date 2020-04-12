//
//  WeatherViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 5/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, Refresh {
    
   @IBOutlet weak var weatherTableView: UITableView!
    
    var locationManager:CLLocationManager?
    //var geocoder = CLGeocoder()
    var latestLongitude:String?
    var latestLatitude:String?
    
    var weatherModel = WeatherAPIRequest.shared
    var cityModel = CityAPIRequest.shared
    var savedLocationManager = SavedLocationManager()
    
    var savedLocations:[SavedLocation]?
    
    var weatherList:[Weather] {
        get { return weatherModel.weatherList }
        set { weatherModel.weatherList = newValue }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        
        let locationNameLabel = cell.viewWithTag(1001) as! UILabel
        let temperatureLabel = cell.viewWithTag(1002) as! UILabel
        let descriptionLabel = cell.viewWithTag(1003) as! UILabel
        let locationIcon = cell.viewWithTag(1004) as! UIImageView
        let weatherIcon = cell.viewWithTag(1005) as! UIImageView
        
        locationNameLabel.text = weatherList[indexPath.row].locationName
        temperatureLabel.text = String(weatherList[indexPath.row].temp) + "°C"
        descriptionLabel.text = weatherList[indexPath.row].description
        weatherIcon.image = UIImage(named: weatherList[indexPath.row].description)
        
        if weatherList[indexPath.row].isCurrentLocation {
            locationIcon.isHidden = false
        } else {
            locationIcon.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Allow ability to swipe to delete, and remove deleted locations
        // from the view, data source and database
        if editingStyle == .delete {
            savedLocationManager.deleteSavedLocation(savedLocation: weatherList[indexPath.row].savedLocation!)
            weatherList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Disable ability to delete tableview cell for current location
        if weatherList[indexPath.row].isCurrentLocation {
            return false
        } else { return true }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
        weatherTableView.dataSource = self
        loadContent()
    }
    
    func loadContent(){
        weatherList = []
        getCurrentLocation()
        getSavedLocations()
    }
    
    func getCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            // Get coordinates of current location
            latestLongitude = String(location.coordinate.longitude)
            latestLatitude = String(location.coordinate.latitude)
            locationManager?.stopUpdatingLocation()
            if let currentLongitude = latestLongitude, let currentLatitude = latestLatitude {
                // Get weather information for current location coordinates
                weatherModel.getWeather(longitude: currentLongitude, latitude: currentLatitude, isCurrentLocation: true, savedLocation: nil)
            } else { locationManager?.startUpdatingLocation() }
        }
    }
    
    func getSavedLocations(){
        // Get saved locations from the database
        savedLocations = savedLocationManager.fetchSavedLocations()
        for location in savedLocations! {
            // Get weather information for saved location coordinates
            weatherModel.getWeather(longitude: String(location.longitude), latitude: String(location.latitude), isCurrentLocation: false, savedLocation: location)
        }
    }
    
    func updateUI(){
        // Ensure weather for current location is displayed first
        weatherList.sort {
            $0.isCurrentLocation && !$1.isCurrentLocation
        }
        weatherTableView.reloadData()
    }
}
