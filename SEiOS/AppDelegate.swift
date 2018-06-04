//
//  AppDelegate.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 04/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import MSAL

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // The MSAL Logger should be set as early as possible in the app launch sequence, before any MSAL
        // requests are made.
        
        let logger = MSALLogger.init()
        
        
        /** When capturing log messages from MSAL you only need to capture either messages where
         containsPII == YES or containsPII == NO, as log messages are duplicated between the
         two, however the containsPII version might contain Personally Identifiable Information (PII)
         about the user being logged in.
         */
        
        logger.setCallback { (logLevel, message, containsPII) in
            
            
            if (!containsPII) {
                
                print("%@", message!)
                
            }
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


/// 
extension AppDelegate {
    /*! @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
     AppAuth authorization request and if so, will look for the code in the response.
     */
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if MSALPublicClientApplication.handleMSALResponse(url) == true {
            print("Received callback!")
        }
        return true
    }
}

