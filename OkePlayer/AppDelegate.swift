//
//  AppDelegate.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 19/11/2020.
//

import UIKit
import AVFoundation
import PackageWithIntercom

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAudioSession()
        setupWindow()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        mainCoordinator?.handleAppTermination()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .moviePlayback)
    }
    
    private func setupWindow() {
        let window = UIWindow()
        self.window = window
        
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator?.start()
    }
}

