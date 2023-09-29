//
//  CLLocationCoordinate2D.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//


import Foundation
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        
        let locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.requestWhenInUseAuthorization()
            
            if let userCoordinates = locationManager.location?.coordinate{
                return userCoordinates
            }
            
        }
        
        return .init(latitude: 27.66273319990253, longitude: 85.30611092643666) //defaulting to some random location
        
        
    }

    static func generateRandomCoodinate() -> CLLocationCoordinate2D {
        let radiusInMeters: Double = 500
        let radiusInDegrees = radiusInMeters / 111300.0
        let randomLatOffset = Double.random(in: -radiusInDegrees ... radiusInDegrees)
        let randomLonOffset = Double.random(in: -radiusInDegrees ... radiusInDegrees)

        let newLatitude = userLocation.latitude + randomLatOffset
        let newLongitude = userLocation.longitude + randomLonOffset

        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
}

