//
//  CustomButton.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 01/10/2023.
//

import SwiftUI

struct CustomButton: View {
    
    let title: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay(alignment: .center, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            })
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .foregroundStyle(.blue)
            .padding()
    }
}

#Preview {
    CustomButton(title: "Sign Up")
}
