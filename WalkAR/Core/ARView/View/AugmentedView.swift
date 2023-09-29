//
//  ContentView.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity


struct AugmentedView : View {
    let modelToBePlaced: Model

    @State private var navigateToHome = false

    var body: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .leading) {
                HStack {
//                    Text("Points: \(PointsManager.shared.points)")
//                        .font(.title)
//                        .foregroundStyle(.white)
//                        .fontWeight(.bold)
//                    Steps()
                }.padding()
                ARViewContainer(modelConfirmedForPlacement: modelToBePlaced)
            }

        })
        .background(
            NavigationLink("", destination: HomeView(), isActive: $navigateToHome)
                .opacity(0) // Hide the navigation link
        )
        .onReceive(NotificationCenter.default.publisher(for: .pointsIncreased)) { _ in

            navigateToHome = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var modelConfirmedForPlacement: Model?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.isUserInteractionEnabled = true

        arView.enableObjectRemoval()

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }

        arView.session.run(config)

        _ = FocusEntity(on: arView, focus: .classic)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = modelConfirmedForPlacement {
            if let modelEntity = model.modelEntity {
                print("adding \(model.modelName) to the scene")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.name = "ObjectAnchor"
                modelEntity.generateCollisionShapes(recursive: true)

                anchorEntity.addChild(modelEntity
                    .clone(recursive: true)
                )
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("unable to load \(model.modelName) to the scene")
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView {
    func enableObjectRemoval() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        addGestureRecognizer(longPressRecognizer)
    }

    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)

        if let entity = entity(at: location) {
            if let anchorEntity = entity.anchor, anchorEntity.name == "ObjectAnchor" {
                anchorEntity.removeFromParent()
                print("removed the object ")
                PointsManager.shared.increasePoints()
                NotificationCenter.default.post(name: .pointsIncreased, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let pointsIncreased = Notification.Name("PointsIncreased")
}


#Preview {
    AugmentedView(modelToBePlaced: Model(modelName: ""))
}
