//
//  PlacementButtonsView.swift
//  MapReality
//
//  Created by London Petway on 4/28/21.
//

import SwiftUI

struct PlacementButtonsView: View {
    
    @Binding var isPlacementEnabled: Bool
    @Binding var modelConfirmedForPlacement: String?
    @Binding var selectedModel: String?
    var body: some View {
        HStack {
            Button(action: {place()}, label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white)
                    .foregroundColor(.red)
                    .cornerRadius(30)
                    .padding(20)
            })
            Button(action: {place()
                self.modelConfirmedForPlacement = self.selectedModel
            }, label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white)
                    .foregroundColor(.green)
                    .cornerRadius(30)
                    .padding(20)
            
        })
        }
    }



func place() {
    isPlacementEnabled.toggle()
}
}
