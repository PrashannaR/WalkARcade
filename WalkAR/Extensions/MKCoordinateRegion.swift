//
//  MKCoordinateRegion.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 2500, longitudinalMeters: 2500)
    }
}
