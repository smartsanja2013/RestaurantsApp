//
//  WelcomeViewController.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var lblAppTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblAppTitle.text = ""
        var charIndex = 0.0
        let titleText = Constants.Main_Title
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.lblAppTitle.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
