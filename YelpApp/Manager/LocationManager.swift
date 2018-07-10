//
//  LocationManager.swift
//  YelpApp
//
//  Created by Ngendo Muhayimana on 2018-07-09.
//  Copyright © 2018 Ngendo Muhayimana. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUser {
    func notAuthorize()
    func gotLocation(coordinate:(lat: Double, lon: Double))
}

class LocationManager:  NSObject, CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let user: LocationUser
    
    init(user: LocationUser) {
        self.user = user
        super.init()

        setupService()
    }
    
    func setupService() {
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            locationManager.startUpdatingLocation()
        }else {
            user.notAuthorize()
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        
        if let  coo = locations.last?.coordinate {
            
            Session.shared.coordinate = (coo.latitude, lon: coo.longitude)
            // user.gotLocation(coordinate: )
            
            //ApiManager().search(completion: {})

        }
        
    }
}
