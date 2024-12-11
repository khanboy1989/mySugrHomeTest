//
//  ContentView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Asset.Images.logo.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
