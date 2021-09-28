//
//  HomeView.swift
//  PayPark
//
//  Created by Jigisha Patel on 2020-09-21.
//

import SwiftUI

struct HomeView: View {
    //environment object invalidates the current view whenever the observable object changes.
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var parkingViewModel: ParkingViewModel
    
    //indication whether a view is currently presented by another view //used to dismiss out of a view //
    @Environment(\.presentationMode) var presentationMode
    
    //navigation selection
    @State private var selection: Int? = nil
    
    var email: String = ""
    
    var body: some View {
        NavigationLink(destination: SignInView(), tag: 1, selection: $selection){}
        NavigationLink(destination: NewParkingView(), tag: 2, selection: $selection){}
        
        ZStack(alignment: .bottom){
            List{
                ForEach(self.parkingViewModel.parkingList, id: \.self){ (parking) in
                    
                    NavigationLink(destination: ParkingDetailView(parking: parking)){
                        
                        HStack{
                            Text("\(Formatter().simplifiedDateDormatter(date: parking.parkingDate))")
                            Text("@ \(parking.buildingCode)")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }
                    
                }
                .onDelete{(indexSet) in
                    for index in indexSet{
                        self.parkingViewModel.deleteParking(index: index)
                    }
                    
                }
                
            }
            
            Button(action:
                    {
                        print("New Parking")
                        self.selection = 2
                    }){
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 155/255, green: 100/255, blue: 255/255))
                    .shadow(color: .green, radius: 1, x: 1, y: 1)
            }
        }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Menu{
                    Button("Delete Account", action: self.deleteAccount)
                    Button("Edit Profile", action: self.editProfile)
                    Button("Sign Out", action: self.signOut)
                }label:{
                    Image(systemName: "gear")
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("PayPark")
        
        .onAppear(){
            self.parkingViewModel.parkingList.removeAll()
            self.parkingViewModel.getAllParkings()
        }
    }
    
    private func deleteAccount(){
        self.userViewModel.deleteUser()
        self.selection = 1
        UserDefaults.standard.removeObject(forKey: "KEY_EMAIL")
        UserDefaults.standard.removeObject(forKey: "COM_PROFJK_PAYPARK_PASSWORD")
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func editProfile(){
        self.userViewModel.loggedInUser?.carPlate = "SHER210"
        self.userViewModel.loggedInUser?.name = "Sheridan"
        self.userViewModel.updateUser()
    }
    
    private func signOut(){
        self.selection = 1
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
