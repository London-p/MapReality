//
//  ContentView.swift
//  MapReality
//
//  Created by London Petway on 4/27/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @State private var isPlacementEnabled = false
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    
    
    var models: [String] = {
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try?
                filemanager.contentsOfDirectory(atPath: path) else {
            return[]
        }
        var availableModels: [String] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            availableModels.append(modelName)
        }
        return availableModels
    }()
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            
            ARViewContainer(modelConfirmedforPlacement: $modelConfirmedForPlacement)
            
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, modelConfirmedForPlacement: $modelConfirmedForPlacement, selectedModel: $selectedModel)
            } else {
            
            ModelPickerView(models: models, isPlacementEnabled: $isPlacementEnabled,selectedModel: $selectedModel)
            
            }
            }
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedforPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        
        if let modelName = self.modelConfirmedforPlacement {
            print("hi")
            
            let filename = modelName + ".usdz"
            let modelEntity = try!
                ModelEntity.loadModel(named: filename)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            
            uiView.scene.addAnchor(anchorEntity)
            
            
            DispatchQueue.main.async {
                self.modelConfirmedforPlacement = nil
            }
 
        }
        
        
        
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

