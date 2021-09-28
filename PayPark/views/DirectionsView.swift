//
//  DirectionsView.swift
//  PayPark
//
//  Created by mac owner on 2020-11-25.
//

import SwiftUI
import MapKit

struct DirectionsView: View {
    @ObservedObject var locationManager = LocationManager()
    @State private var parkingCoordinates = CLLocationCoordinate2D()
    
    var location: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    var body: some View {
        VStack{
            MapView(location: self.location, coordinates: self.parkingCoordinates)
        }
        .onAppear(){
            if (self.lat != 0 && self.lng != 0){
                self.parkingCoordinates = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
            }
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}

struct MapView : UIViewRepresentable{
//    typealias UIViewType = <#type#>
    
    @ObservedObject var locationManager = LocationManager()
    private var location: String = ""
    private var parkingCoordinates: CLLocationCoordinate2D
    private let regionRadius: CLLocationDistance = 300
    
    init(location: String, coordinates: CLLocationCoordinate2D){
        self.location = location
        self.parkingCoordinates = coordinates
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        
        map.mapType = MKMapType.standard
        map.showsUserLocation = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isUserInteractionEnabled = true
        
        let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius * 4.0, longitudinalMeters: regionRadius * 4.0)
        
        map.setRegion(region, animated: true)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let sourceCoordinates = CLLocationCoordinate2D(latitude: 43.642567, longitude: -79.387054)
        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: regionRadius * 4.0, longitudinalMeters: regionRadius * 4.0)
        
        uiView.setRegion(region, animated: true)
    }
}

