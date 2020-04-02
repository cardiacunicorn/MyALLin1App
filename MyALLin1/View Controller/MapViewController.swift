//
//  MapViewController.swift
//  MyALLin1
//
//  Created by Chris Bowe on 2/4/20.
//  Copyright © 2020 MyALLin1. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
    }
}
