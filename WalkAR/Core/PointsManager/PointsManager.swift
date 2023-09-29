//
//  PointsManager.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Foundation

class PointsManager{
    var points: Int = 0
    
    static let shared = PointsManager()
    
    func increasePoints(){
        points += 10
    }
}
