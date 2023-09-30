//
//  MapBoxViewControllerRepresentable.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Foundation
import SwiftUI

struct MapBoxViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapBoxViewController

    func makeUIViewController(context: Context) -> MapBoxViewController {
        // Return MyViewController instance
        let vc = MapBoxViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: MapBoxViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
