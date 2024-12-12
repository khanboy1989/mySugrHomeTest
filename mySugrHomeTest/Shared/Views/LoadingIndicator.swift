//
//  LoadingIndicator.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 12/12/2024.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating = false
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1.0) // Creates the arc
            .stroke(Color.blue, lineWidth: 5) // Blue border with thickness
            .frame(width: 50, height: 50) // Size of the indicator
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0)) // Rotating animation
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }.onDisappear {
                isAnimating = false
            }
    }
}

#Preview {
    LoadingIndicator()
}
