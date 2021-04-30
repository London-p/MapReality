//
//  ContentView.swift
//  MapReality
//
//  Created by London Petway on 4/27/21.
//

import SwiftUI
import RealityKit
import ARKit
import MapKit
import CoreLocation


struct ContentView : View {
    
    @State private var isPlacementEnabled = false
    @State private var selectedModel: String?
    @State private var modelConfirmedForPlacement: String?
    @State private var mapEnabled = false
    @State var map = MKMapView()
    @State var manager = CLLocationManager()
    @State var alert = false
    @State var source : CLLocationCoordinate2D!
    @State var destination : CLLocationCoordinate2D!
    @State var name = ""
    
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
            
            if self.mapEnabled {
                ZStack {
                    VStack {
                        HStack {
                            
                            VStack {
                            Text("Pick a Location")
                                .font(.title)
                                . padding(.leading)
                            
                            if self.destination != nil{
                                Text(self.name)
                                    .bold()
                            }
                            }
                            Button(action: {mapEnabled.toggle()}, label: {
                                Text("Reality")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                        }
                        .padding(.top, 50)
                       
                        
                        MapView1(map: self.$map, manager: self.$manager, alert: self.$alert, source: self.$source, destination: self.$destination, name: self.$name)
                        .onAppear {
                                self.manager.requestAlwaysAuthorization()
                            }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: self.$alert) { () -> Alert in
                    
                    Alert(title: Text("Error"), message: Text("Please Enable Location in Settings"), dismissButton: .destructive(Text("Ok")))
                }
            
            
            } else {
            ARViewContainer(modelConfirmedforPlacement: $modelConfirmedForPlacement)
            
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, modelConfirmedForPlacement: $modelConfirmedForPlacement, selectedModel: $selectedModel)
            } else {
                
            ModelPickerView(models: models, isPlacementEnabled: $isPlacementEnabled,selectedModel: $selectedModel, mapEnabled: $mapEnabled)
                
            }
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

