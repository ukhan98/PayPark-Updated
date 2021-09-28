//
//  NewParkingView.swift
//  PayPark
//
//  Created by mac owner on 2020-11-24.
//

import SwiftUI

struct NewParkingView: View {
    @ObservedObject var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var parkingViewModel: ParkingViewModel
    
    @State private var buildingCode: String = ""
    @State private var carPlate: String = ""
    @State private var unitNumber: String = ""
    @State private var parkingDate = Date()
    @State private var duration: Int = 0
    @State private var parkingLocation: String = ""
    @State private var parkingLat: Double = 0.0
    @State private var parkingLng: Double = 0.0


    let durationHours = [4,8,10,24]
    
    var body: some View {
        VStack{
            Form{
                Section{
                    TextField("Car Plate", text: $carPlate).autocapitalization(.allCharacters)
                    TextField("Building Code", text: $buildingCode)
                    TextField("Unit Number", text: $unitNumber)
                    DatePicker(selection: $parkingDate, in: ...Date()){
                        Text("Parking Date")
                    }
                }
                
                Section(header: Text("Duration of parking")){
                    Picker(selection: $duration, label: Text("Duration"), content: /*@START_MENU_TOKEN@*/{
                        ForEach(0 ..< durationHours.count){ item in
                            Text("\(durationHours[item]) hours")
                        }
                    }/*@END_MENU_TOKEN@*/).pickerStyle(SegmentedPickerStyle())
                }
                
                Section{
                    HStack{
                    TextField("Parking Location", text:$parkingLocation)
                    Button(action: {
                        self.getLocation()
                    }) {
                        Image(systemName: "location")
                    }
                    }
                }
            }//form
            
            Button(action:{
                self.addParking()
            }){
                Text("Add Parking")
                    .accentColor(Color.white)
                    .padding()
                    .background(Color(UIColor.darkGray))
                    .cornerRadius(5.0)
            }
        }
    }
    
    private func addParking(){
        var newParking = Parking()
        newParking.email = self.userSettings.userEmail
        newParking.carPlate = self.carPlate
        newParking.buildingCode = self.buildingCode
        newParking.unitNumber = self.unitNumber
        newParking.duration = self.durationHours[self.duration]
        newParking.parkingLocation = self.parkingLocation
        newParking.parkingDate = self.parkingDate
        newParking.parkingLng = self.parkingLng
        newParking.parkingLat = self.parkingLat
        
        print(#function, "New Parking : \(newParking)")
        
        parkingViewModel.addParking(newParking: newParking)
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func getLocation(){
        print(#function, "Getting Location")
        self.locationManager.start()
        
        print(#function, "Address : \(self.locationManager.address)")
        print(#function, "Lat : \(self.locationManager.lat)")
        print(#function, "Lng : \(self.locationManager.lng)")
        
        self.parkingLocation = self.locationManager.address
        self.parkingLat = self.locationManager.lat
        self.parkingLng = self.locationManager.lng
        
    }
}

struct NewParkingView_Previews: PreviewProvider {
    static var previews: some View {
        NewParkingView()
    }
}

