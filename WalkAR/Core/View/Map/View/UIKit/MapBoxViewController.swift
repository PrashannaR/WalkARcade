//
//  MapBoxViewController.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//


import CoreLocation
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation
import UIKit

class MapBoxViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Define two waypoints to travel between
        let user: CLLocationCoordinate2D = .userLocation
        print("user location: ", user)
        let origin = Waypoint(coordinate: user, name: "My Location")
        let destination = Waypoint(coordinate: .generateRandomCoodinate(), name: "Destination")

        // Set options
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])

        // Request a route using MapboxDirections.swift
        Directions.shared.calculate(routeOptions) { [weak self] _, result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(response):
                guard let self = self else { return }
                // Pass the first generated route to the the NavigationViewController
                let viewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: routeOptions)
                viewController.modalPresentationStyle = .popover
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
