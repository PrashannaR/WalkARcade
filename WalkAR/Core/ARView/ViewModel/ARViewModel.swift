//
//  ARViewModel.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import Foundation

class ARViewModel: ObservableObject {
    @Published var isPlacementEnabled: Bool = false

    @Published var selectedModel: Model?
    @Published var modelConfirmedForPlacement: Model?

    func togglePlacement() {
        isPlacementEnabled.toggle()
        selectedModel = nil
    }

    // get the models
    @Published var models: [Model] = {
        let fileManager = FileManager.default

        guard let path = Bundle.main.resourcePath,
              let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }

        var availableModels: [Model] = []

        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            availableModels.append(model)
        }

        return availableModels

    }()
    
    func generateRandomModel() -> Model {
        if !models.isEmpty {
            let randomIndex = Int.random(in: 0 ..< models.count)
            return models[randomIndex]
        } else {
            print("no random element")
            return models[0]
        }
    }
    
}
