//
//  AppDelegate.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK:- Properties
    var window: UIWindow?
    var reachability:Reachability?
    var network:(isAvailable:Bool, type:Reachability.Connection) = (false, .unavailable)
    
    //MARK:- LifeCycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupReachability()
        return true
    }

}

//MARK: Reachability
extension AppDelegate {
    func setupReachability() {
        reachability = try! Reachability()
        
        reachability?.whenReachable = { reachability in
            self.network = ((reachability.connection == .wifi || reachability.connection == .cellular) , reachability.connection)
        }
        reachability?.whenUnreachable = { _ in
            self.network = (false, .unavailable)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
