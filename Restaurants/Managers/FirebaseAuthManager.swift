//
//  LoginManager.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 11/7/21.
//

import Foundation
import Firebase

struct FirebaseAuthManager {
    // login
    func authenticateUser(email: String, password: String, completionHandler: @escaping(_ loginData: AuthResponse)->()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error{
                // return error back to the caller
                completionHandler(AuthResponse(errorMessage: err.localizedDescription, response: nil))
            }
            else{
                // return data back to the caller
                completionHandler(AuthResponse(errorMessage: nil, response: authResult))
            }
            
        }
    }
    
    // registration
    func registerUser(email: String, password: String, completionHandler: @escaping(_ registerData: AuthResponse)->()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error{
                // return error back to the caller
                completionHandler(AuthResponse(errorMessage: err.localizedDescription, response: nil))
            }
            else{
                // return data back to the caller
                completionHandler(AuthResponse(errorMessage: nil, response: authResult))
            }
            
        }
    }
    
    // logout
    func logout(completionHandler: @escaping(_ loggedOut: Bool)->()) {
        do {
            try Auth.auth().signOut()
            // return error back to the caller
            completionHandler(true)
        } catch _ as NSError {
            completionHandler(false)
        }
    }
}
