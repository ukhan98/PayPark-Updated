//
//  ParkingDetailView.swift
//  PayPark
//
//  Created by mac owner on 2020-11-24.
//

import SwiftUI

struct ParkingDetailView: View {
    var parking: Parking
    @State private var selection: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            NavigationLink(destination: DirectionsView(location: self.parking.parkingLocation,
                                                       lat: self.parking.parkingLat,
                                                       lng: self.parking.parkingLng),
                           tag: 1, selection: $selection){}
            
            Text("\(Formatter().simplifiedDateDormatter(date: parking.parkingDate))")
                .fontWeight(.bold)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.center)
            
            Text("Building Code : \(parking.buildingCode)")
            Text("Unit Number: \(parking.unitNumber)")
            Text("Car Plate: \(parking.carPlate)")
            Text("Duration: \(parking.duration) hours")
            
            VStack{
                Text("Location: \(parking.parkingLocation)")
                .bold()
                
                Button(action: {
                    self.selection = 1
                }){
                    Image(systemName: "arrow.up.right.diamond.fill")
                        .foregroundColor(Color.blue)
                }
            }
            
            Spacer()
        }
        .padding(5)
        .navigationBarTitle(Text("Parking Details"))
    }
}

struct ParkingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingDetailView(parking: Parking())
    }
}
