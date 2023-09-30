//
//  MyAreaMap.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 29/09/2023.
//

import SwiftUI

struct MyAreaMap: View {
    var body: some View {
        VStack {
            MapBoxViewControllerRepresentable().ignoresSafeArea()
        }
    }
}

#Preview {
    MyAreaMap()
}
