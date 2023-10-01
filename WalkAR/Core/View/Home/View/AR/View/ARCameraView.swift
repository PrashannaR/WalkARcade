//
//  ARCameraView.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import ARKit
import FocusEntity
import RealityKit
import SwiftUI

struct ARCameraView: View {
    let modelToBePlaced: Model
    
    @State var user: LeaderboardData?
    @State var myUser: LeaderboardData = LeaderboardData(username: "prashannar", points: 70, steps: 2000)
    @State private var navigateToHome = false
    @StateObject var healthManager = HealthManager()
    
    @State var myPoints: Int?

    var body: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Points: \(myUser.points)")
                        .font(.title)
                        .fontWeight(.bold)
                }.padding()
                ARViewContainer(modelConfirmedForPlacement: modelToBePlaced)
            }

        })
        .onAppear {
            loadData()
            healthManager.fetchTodaysStep()
        }
        .background(
            NavigationLink("", destination: HomeView(), isActive: $navigateToHome)
                .opacity(0) // Hide the navigation link
        )
        .onReceive(NotificationCenter.default.publisher(for: .pointsIncreased)) { _ in
            updatePointsInBackend()

            navigateToHome = true
        }
    }
}

extension ARCameraView{
    
    // Function to update points in the backend
    func updatePointsInBackend() {
        guard let url = URL(string: "http://192.168.101.121:8000/leaderboard/prashannar/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let updatedData: [String: Any] = [
            "username": myUser.username,
            "points": myUser.points + 10,  // Increment points by 10
            "steps": Int(healthManager.todaysSteps)
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updatedData)
        } catch {
            print("Error serializing JSON: \(error)")
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error updating user data: \(error)")
            } else {
                // Reload data after update (optional)
                loadData()
            }
        }.resume()
    }
    
    func loadData() {
        guard let url = URL(string: "http://192.168.101.121:8000/leaderboard/prashannar/") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(LeaderboardData.self, from: data)
                    DispatchQueue.main.async {
                        self.myUser = decodedData
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }

}



// MARK: ARView Container

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

// MARK: remove the object from the scene

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

#Preview {
    ARCameraView(modelToBePlaced: Model(modelName: ""))
}

extension Notification.Name {
    static let pointsIncreased = Notification.Name("PointsIncreased")
}
