//
//  AlertManager.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 10/7/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    // alert with single button
    func showDistructiveAlert(title: String?, message: String?, buttonText: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:buttonText , style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
