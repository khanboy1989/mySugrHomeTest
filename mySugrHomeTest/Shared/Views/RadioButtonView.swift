//
//  RadioButtonView.swift
//  mySugrHomeTest
//
//  Created by Serhan Khan on 11/12/2024.
//

import Foundation
import SwiftUI

struct RadioButtonView: View {
    var title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(isSelected ?
                              Color.blue : Color.clear)
                        .padding(4)
                )
            
            Text(title)
        }
    }
}

#Preview {
    RadioButtonView(title: "mg/L", isSelected: .constant(true))
}
