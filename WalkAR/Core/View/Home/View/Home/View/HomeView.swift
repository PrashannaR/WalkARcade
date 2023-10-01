//
//  HomeView.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = ContentViewModel()
    @State var model: Model = Model(modelName: "")

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                
                    VStack(alignment: .leading) {
                        Leaderboard()
                        
                        Spacer()

                        Image("step")
                            .resizable()
                            .scaledToFit()
                    }

                .padding()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink {
                            MyAreaMap()

                        } label: {
                            CustomButton(imageName: "map.fill")
                        }

                        NavigationLink {
                            ARCameraView(modelToBePlaced: model)
                        } label: {
                            CustomButton(imageName: "camera.fill")
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Text("WalkARcade")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                }
            })
            .onAppear {
                DispatchQueue.main.async {
                    model = vm.generateRandomModel()
                    print("generated model: ", model.modelName)
                }
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
    private func CustomButton(imageName: String) -> some View {
        return VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 40)
                .foregroundStyle(.link)
                .overlay(alignment: .center) {
                    HStack {
                        Image(systemName: imageName)
                    }
                    .foregroundStyle(.white)
                }
        }
    }
}
