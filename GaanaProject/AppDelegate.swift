//
//  AppDelegate.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let rootNavController = UINavigationController(rootViewController: homeVC)
        self.window?.rootViewController = rootNavController
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.startMonitoring()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        ReachabilityManager.sharedInstance.stopMonitoring()
    }
}

