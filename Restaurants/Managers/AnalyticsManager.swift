//
//  AnalyticsManager.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 11/7/21.
//

import UIKit
import Foundation
import Firebase

class AnalyticskManager {
    // login event
    func addLoginEvent(email:String) {
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventLogin, parameters: [
            "Email": email
        ])
    }
    // signup event
    func addRegisterEvent(email:String) {
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventSignUp, parameters: [
            "Email": email
        ])
    }
    // app lauch event
    func addFisrtAppLauch() {
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }
}
