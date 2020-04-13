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


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    // Get if user has authorized app to use location services, if not request again.
    func checkLocationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Location manager gets users most recent location
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        // get users most recent location
        let lastLocation: CLLocation = locations[locations.count - 1]
        // filter only cafes as points of interest
        filterPointsOfInterest()
        // animate map to the users last known location
        animateMap(lastLocation)
    }
    
    // Zoom in map to the users current location
    func animateMap(_ location:CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func filterPointsOfInterest() {
        let categories:[MKPointOfInterestCategory] = [.cafe]
        let filters = MKPointOfInterestFilter(including: categories)
        mapView.pointOfInterestFilter = .some(filters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
