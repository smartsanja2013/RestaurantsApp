//
//  RegisterViewController.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    
    // loading hud
    let hud = JGProgressHUD()
    
    private let authManager = FirebaseAuthManager()
    private let analyticsManager = AnalyticskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action methods
    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        // check internet connection
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            // show loadning indicator
            hud.textLabel.text = Constants.Fetching_Data
            hud.show(in: self.view)
            
            // user registration through firebase
            if let email = txtFldEmail.text, let password = txtFldPassword.text{
                // register user
                authManager.registerUser(email: email, password: password) { (AuthResponse) in
                    self.hud.dismiss()
                    if let err = AuthResponse.errorMessage {
                        print("FirebaseRegistrationError \(err)")
                        self.showDistructiveAlert(title: "", message: err, buttonText: Constants.Generic_Ok)
                    }
                    else {
                        // update isLoggedIn flag
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        // add signup event in firebase analytics
                        self.analyticsManager.addRegisterEvent(email: email)
                        // registration success. navigate to MapViewController
                        self.gotoMapViewController()
                    }
                    
                }
            }
        }
        else{
            print("Internet Connection not Available!")
            // show no neteork error message
            self.showDistructiveAlert(title:Constants.No_Network_Title, message:Constants.No_Network_Message, buttonText:Constants.Generic_Ok)
        }
    }
    
    func gotoMapViewController() {
        // set the MapViewContrller as root
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewContrller = storyboard.instantiateViewController(identifier: "MainNavigationController") as! MainNavigationController
        UIApplication.shared.windows.first?.rootViewController = mapViewContrller
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
