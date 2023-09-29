//
//  Steps.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import SwiftUI

struct Steps: View {
    @StateObject var healthManager = HealthManager()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today's Goal")
                    .font(.title)
                Spacer()
                Text("10,000")
                    .font(.title2)
            }

            Text("Current Steps: \(Int(healthManager.todaysSteps))")
                .font(.headline)

        }.padding()
            .onAppear {
                healthManager.fetchTodaysStep()
            }
    }
}

#Preview {
    Steps()
}
