//
//  ModelPickerView.swift
//  MapReality
//
//  Created by London Petway on 4/28/21.
//

import SwiftUI

struct ModelPickerView: View {
    var models: [String]
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) { index in
                    Button(action: {isPlacementEnabled.toggle()
                        self.selectedModel = self.models[index]
                    }) {
                        Image(uiImage: UIImage(named: self.models[index])!)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}


