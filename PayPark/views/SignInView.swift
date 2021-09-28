//
//  ContentView.swift
//  PayPark
//
//  Created by Jigisha Patel on 2020-09-21.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var email:String = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "COM_PROFJK_PAYPARK_PASSWORD") ?? ""
    @State private var rememberMe: Bool = true
    @State private var selection: Int? = nil
    @State private var invalidLogin: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                    SecureField("Password", text: self.$password)
                    
                    VStack(alignment: .trailing, spacing: 10){
                        NavigationLink(destination: Text("Password Recovery"), tag: 1, selection: $selection){EmptyView()}
                        NavigationLink(destination: SignUpView(), tag: 2, selection: $selection) {}
                        
                        Toggle(isOn: self.$rememberMe, label: {
                            Text("Remember my credentials")
                        })
                        
                        Button(action: {
                            print("Forgot button clicked")
                            self.selection = 1
                        }){
                            Text("Forgot Password ?")
                                .foregroundColor(Color.blue)
//                            NavigationLink("Forgot Password?", destination: Text("Password Recovery"))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            print("Create account clicked")
                            self.selection = 2
                        }){
                            Text("New Customer? Create Account")
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }//VStack
                }//Form
                
                Section{
                    NavigationLink(destination: HomeView(email: self.email), tag: 3, selection: $selection){}
                    
                    Button(action:{
                        print("Sign In Clicked")
                        if (self.isValidData()){
                            if (self.validateUser()){
                                print("Login Successful")
                                
                                //save login credentials to UserDefaults
                                if (self.rememberMe){
                                    //save to UserDefaults
                                    UserDefaults.standard.setValue(self.email, forKey: "KEY_EMAIL")
                                    UserDefaults.standard.setValue(self.password, forKey: "COM_PROFJK_PAYPARK_PASSWORD")
                                }else{
                                    //remove from UserDefaults
                                    UserDefaults.standard.removeObject(forKey: "KEY_EMAIL")
                                    UserDefaults.standard.removeObject(forKey: "COM_PROFJK_PAYPARK_PASSWORD")
                                }
                                
                                
                                userSettings.userEmail = self.email
                                self.selection = 3
                            }else{
                                print("Incorrect email/password.")
                                self.invalidLogin = true
                            }
                        }
                    }){
                        Text("Sign In")
                            .accentColor(Color.white)
                            .padding()
                            .background(Color(UIColor.darkGray))
                            .cornerRadius(5.0)
                    }
                    .alert(isPresented: self.$invalidLogin){
                        Alert(
                            title: Text("Error"),
                            message: Text("Incorrect Login/Password"),
                            dismissButton: .default(Text("Try Again !"))
                        )
                    }//alert
                }//Section
            }//VStack
            .navigationBarTitle("PayPark", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(trailing:
//                                    Button(action: {
//                                        print("Settings Clicked")
//                                    }){
////                                        Text("Settings")
////                                        https://sfsymbols.com/
//                                        Image(systemName: "gear")
//                                    })
        }//NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(){
//            self.email = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
//            self.password = UserDefaults.standard.string(forKey: "COM_PROFJK_PAYPARK_PASSWORD") ?? ""
            
            self.userViewModel.getAllUsers()
            
            for user in self.userViewModel.userList{
                print(#function, "Name : \(user.name ?? "Unknown") Email: \(user.email!) Password: \(user.password!) CarPlate: \(user.carPlate ?? "Unknown")")
            }
        }
    }//body
    
    private func isValidData() -> Bool{
        if self.email.isEmpty{
            return false
        }
        
        if self.password.isEmpty{
            return false
        }
        
        return true
    }
    
    private func validateUser() -> Bool{
        self.userViewModel.findUserByEmail(email: self.email)
        
        if (self.userViewModel.loggedInUser != nil){
            if (self.password == self.userViewModel.loggedInUser!.password){
                return true
            }
        }else{
            self.invalidLogin = true
            
            return false
        }
        return false
    }
}//SignInView

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


//Task - save the state (On/Off) of Toggle button in UserDefaults and read it and assign the same state to the Toggle when you display UI
