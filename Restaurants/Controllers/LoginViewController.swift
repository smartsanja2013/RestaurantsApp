//
//  LoginViewController.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    
    // loading hud
    let hud = JGProgressHUD()
    
    private let analyticsManager = AnalyticskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action methods
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // check internet connection
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            // show loadning indicator
            hud.textLabel.text = Constants.Fetching_Data
            hud.show(in: self.view)

            // initiate firebase login
            if let email = txtFldEmail.text, let password = txtFldPassword.text{
                Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
                    if let err = error{
                        print("FirebaseLoginError \(err.localizedDescription)")
                        showDistructiveAlert(title: "", message: err.localizedDescription, buttonText: Constants.Generic_Ok)
                    }
                    else{
                        // update isLoggedIn flag
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        // add login event in firebase analytics
                        analyticsManager.addLoginEvent(email: email)
                        
                        // login success. go to MapViewController
                        gotoMapViewController()
                    }
                    
                    hud.dismiss()
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
