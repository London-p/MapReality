//
//  Map.swift
//  MapReality
//
//  Created by London Petway on 4/29/21.
//

import SwiftUI
import MapKit
import CoreLocation




struct MapView1 : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return MapView1.Coordinator(parent1: self)
    }
    
    
    
    @Binding var map : MKMapView
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination : CLLocationCoordinate2D!
    @Binding var name : String
    
    
    func makeUIView(context: Context) -> MKMapView{
        map.delegate = context.coordinator
        manager.delegate = context.coordinator
        map.showsUserLocation = true
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.tap(ges:)))
        map.addGestureRecognizer(gesture)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject,MKMapViewDelegate,CLLocationManagerDelegate{
        
        var parent : MapView1
        
        init(parent1: MapView1) {
            parent = parent1
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied{
                self.parent.alert.toggle()
            }
            else{
                self.parent.manager.startUpdatingLocation()
            }
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let region = MKCoordinateRegion(center: locations.last!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.parent.source = locations.last!.coordinate
            self.parent.map.region = region
    }
        @objc func tap(ges: UITapGestureRecognizer){
            let location = ges.location(in: self.parent.map)
            let mplocation = self.parent.map.convert(location, toCoordinateFrom: self.parent.map)
           
            
            let point = MKPointAnnotation()
            point.subtitle = "Destination"
            point.coordinate = mplocation
            
            self.parent.destination = mplocation
            
            let decoder = CLGeocoder()
            decoder.reverseGeocodeLocation(CLLocation(latitude: mplocation.latitude, longitude: mplocation.longitude)) { (places, err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                self.parent.name = places?.first?.name ?? ""
                point.title = places?.first?.name ?? ""
            }
            
            self.parent.map.removeAnnotations(self.parent.map.annotations)
            self.parent.map.addAnnotation(point)
        }
    
}

}



