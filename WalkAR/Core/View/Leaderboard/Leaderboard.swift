//
//  Leaderboard.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 01/10/2023.
//

import SwiftUI

struct User: Codable, Identifiable {
    let id = UUID()
    let username: String
    let points: Int
    let steps: Int
}

struct LeaderboardData: Codable {
    let username: String
    let points: Int
    let steps: Int
}

struct Leaderboard: View {
    @StateObject var healthManager = HealthManager()

    @State private var users: [User] = []

    @State private var myUser: LeaderboardData = LeaderboardData(username: "", points: 0, steps: 0)

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    Color.white.ignoresSafeArea()

                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hi \(myUser.username)!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("Have a quick look into your stats")
                                    .font(.headline)
                                    .foregroundStyle(Color.black.opacity(0.2))
                                HStack {
                                    Text("Points: \(myUser.points)")
                                        .foregroundStyle(Color.black.opacity(0.3))
                                        .font(.headline)
                                    Spacer()
                                    Text("Steps: \(Int(healthManager.todaysSteps))")
                                        .foregroundStyle(Color.black.opacity(0.3))
                                        .font(.headline)
                                }
                            }
                           
                        }
                        .foregroundColor(Color.black)
                        .padding(.bottom, 30)

                        Text("Leaderboard")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.blue)
                        Text("Look how well you are performing among all the other users")
                            .lineLimit(2)
                            .font(.headline)
                            .foregroundStyle(Color.black.opacity(0.2))

                        List(users) { user in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(user.username)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                Text("Points: \(user.points)")
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .font(.headline)
                            }
                            .foregroundColor(Color.black)
                            .listRowBackground(Color.white)
                        }.listStyle(.plain)
                    }
                    .background {
                        Color.white
                    }
                }
                .padding()
                .onAppear {
                    fetchData()
                    loadData()
                    healthManager.fetchTodaysStep()
                }
            }
        }
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

        URLSession.shared.dataTask(with: request) { data, _, error in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
