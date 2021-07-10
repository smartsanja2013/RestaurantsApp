//
//  SceneDelegate.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        // retreive login status
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if(isLoggedIn){
            // if user already loggedin, set MapViewController as the root
            let mapViewController = storyBoard.instantiateViewController(identifier: "MainNavigationController") as! MainNavigationController
            window?.rootViewController = mapViewController
            window?.makeKeyAndVisible()
        }
        else{
            // if user not loggedin, set WelcomeViewController as the root
            let welcomeContrller = storyBoard.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
            window?.rootViewController = welcomeContrller
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
}

