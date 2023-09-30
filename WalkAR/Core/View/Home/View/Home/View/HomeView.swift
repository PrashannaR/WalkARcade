//
//  HomeView.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//


import SwiftUI

struct LeaderboardData: Codable {
    let username: String
    let points: Int
    let steps: Int
}

struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let points: Int
    let steps: Int
}


struct HomeView: View {
    @StateObject var vm = ContentViewModel()
    @State var model: Model = Model(modelName: "")
    
    @State private var myUser: LeaderboardData = LeaderboardData(username: "", points: 0, steps: 0)

    @State private var users: [User] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(alignment: .leading) {
                        //personal details
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(myUser.username)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Points: \(myUser.points)")
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .font(.headline)
                            }
                            Spacer()
                            Text("Steps: \(myUser.steps)")
                                .foregroundStyle(Color.black.opacity(0.3))
                                .font(.headline)
                        }
                        .foregroundColor(Color.black)
                        
                        //leaderboard
                        Text("Leaderboard")
                            .font(.title)
                            .foregroundStyle(.blue)
                        List(users) { user in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(user.username)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("Points: \(user.points)")
                                        .foregroundStyle(Color.black.opacity(0.3))
                                        .font(.headline)
                                }
                                Spacer()
                                Text("Steps: \(user.steps)")
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .font(.headline)
                            }
                            .foregroundColor(Color.black)
                        }

                        
                        
                        Spacer()

                        NavigationLink {
                            MyAreaMap()
                            //Leaderboard()

                        } label: {
                            CustomButton(imageName: "map.fill", title: "Maps")
                        }

                        NavigationLink {
                            ARCameraView(modelToBePlaced: model)
                        } label: {
                            CustomButton(imageName: "camera.fill", title: "AR")
                        }

                        NavigationLink {
                            Steps()
                        } label: {
                            CustomButton(imageName: "figure.walk", title: "Steps")
                        }
                    }
                }.padding()
            }
                .onAppear {
                    DispatchQueue.main.async {
                        model = vm.generateRandomModel()
                        print("generated model: ", model.modelName)
                    }
                    loadData()
                    fetchData()
                }
                .onAppear {
                    NotificationCenter.default.addObserver(
                        forName: .pointsIncreased,
                        object: nil,
                        queue: nil
                    ) { _ in
                    }
                }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    private func CustomButton(imageName: String, title: String) -> some View {
        return VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 70)
                .foregroundStyle(.link)
                .overlay(alignment: .center) {
                    HStack {
                        Image(systemName: imageName)

                        Text(title)
                            .font(.title2)
                            .fontWeight(.heavy)
                    }
                    .foregroundStyle(.white)
                }
        }
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
    
    func fetchData() {
        let config = URLSessionConfiguration.default
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        config.waitsForConnectivity = true

        _ = URLSession(configuration: config)
        
        guard let url = URL(string: "http://192.168.101.121:8000/leaderboard/") else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("csrftoken=hFTtUxKrUhxPnge7Hu0QnIrx3KCMzfge; sessionid=pvadi9d4kj4yw69mdg1afad8zzee2sn1", forHTTPHeaderField: "Cookie")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([String: [User]].self, from: data)
                    if let usersArray = decodedData["users"] {
                        DispatchQueue.main.async {
                            users = usersArray
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
