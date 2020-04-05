//
//  WeatherViewController.swift
//  MyALLin1
//
//  Created by Erin Carroll on 5/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//

import UIKit

import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, Refresh {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    var locationManager:CLLocationManager?
    var latestLongitude:String?
    var latestLatitude:String?
    
    var model = WeatherAPIRequest.shared
    
    var weatherList:[Weather] {
        get { return model.weatherList }
        set { model.weatherList = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        locationNameLabel.text = "-"
        temperatureLabel.text = "-°C"
        descriptionLabel.text = "-"
        getLocation()
    }
    
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            latestLongitude = String(location.coordinate.longitude)
            latestLatitude = String(location.coordinate.latitude)
            locationManager?.stopUpdatingLocation()
            if let currentLongitude = latestLongitude, let currentLatitude = latestLatitude {
                model.getWeather(longitude: currentLongitude, latitude: currentLatitude, isCurrentLocation: true)
            } else { locationManager?.startUpdatingLocation() }
        }
    }
    
    func updateCurrentWeather() {
        for weather in weatherList {
            if weather.isCurrentLocation == true {
                locationNameLabel.text = weather.locationName
                temperatureLabel.text = String(weather.temp) + "°C"
                descriptionLabel.text = weather.description
                weatherImage.image = UIImage(named: weather.description)
            }
        }
    }
}
