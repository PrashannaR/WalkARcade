//
//  Model.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Combine
import Foundation
import RealityKit
import UIKit


class Model{
    var modelName: String?
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable?
    
    
    init(modelName: String) {
        self.modelName = modelName
        image = UIImage(named: modelName) ?? UIImage(named: "toy_biplane_idle")!

        let filename = modelName + ".usdz"
        cancellable = ModelEntity.loadModelAsync(named: filename).sink(receiveCompletion: { _ in
            print("Unable to load model entity for \(self.modelName)")
        }, receiveValue: { modelEntity in
            self.modelEntity = modelEntity
            print("sucessfully loaded model entity for \(self.modelName)")
        })
    }
    
}
