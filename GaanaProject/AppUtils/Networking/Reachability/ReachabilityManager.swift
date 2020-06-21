//
//  ReachabilityManager.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 21/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    
    static let sharedInstance = ReachabilityManager()
    private override init() {
        
    }
    
    //******* Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)   *******//
    private var reachabilityStatus: Reachability.Connection = .unavailable
    var isNetworkAvailable : Bool = true

    // Reachability instance for Network status monitoring
    let reachability = try! Reachability()
    
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachabilityObject = notification.object as! Reachability
        reachabilityStatus = reachabilityObject.connection
        if reachabilityStatus == .unavailable {
            self.isNetworkAvailable = false
        } else {
            self.isNetworkAvailable = true
        }
    }
    
    // Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    // Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }

}
