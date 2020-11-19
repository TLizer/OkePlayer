//
//  AppDelegate.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 19/11/2020.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        
        return true
    }
    
    private func setupWindow() {
        let window = UIWindow()
        self.window = window
        
        let controller = ViewController()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}

