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
                
                ScrollView {
                    
                    VStack(alignment: .leading) {
                        
                        Leaderboard()
                        
                        
                        Spacer()

                        NavigationLink {
                            MyAreaMap()
                           

                        } label: {
                            CustomButton(imageName: "map.fill", title: "Maps")
                        }

                        NavigationLink {
                            ARCameraView(modelToBePlaced: model)
                        } label: {
                            CustomButton(imageName: "camera.fill", title: "AR")
                        }
                        
                        Image("step")
                            .resizable()
                            .scaledToFit()

                    }
                    .background {
                        Color.white
                    }
                }.padding()
            }
                .onAppear {
                    DispatchQueue.main.async {
                        model = vm.generateRandomModel()
                        print("generated model: ", model.modelName)
                    }
        
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
    

}
