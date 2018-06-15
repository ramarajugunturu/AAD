//
//  SESettingsViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 14/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import MSAL

class SESettingsViewController: SEBaseViewController {

    
    var applicationContext = MSALPublicClientApplication.init()
    let kClientID = "abf2827a-f496-450f-810f-e5c236360d62"
    let kAuthority = "https://login.microsoftonline.com/common/"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        // Do any additional setup after loading the view.
        
        do {
            
            /**
             
             Initialize a MSALPublicClientApplication with a given clientID and authority
             
             - clientId:     The clientID of your application, you should get this from the app portal.
             - authority:    A URL indicating a directory that MSAL can use to obtain tokens. In Azure AD
             it is of the form https://<instance/<tenant>, where <instance> is the
             directory host (e.g. https://login.microsoftonline.com) and <tenant> is a
             identifier within the directory itself (e.g. a domain associated to the
             tenant, such as contoso.onmicrosoft.com, or the GUID representing the
             TenantID property of the directory)
             - Parameter error       The error that occurred creating the application object, if any, if you're
             not interested in the specific error pass in nil.
             
             */
            
            self.applicationContext = try MSALPublicClientApplication.init(clientId: kClientID, authority: kAuthority)
            
        } catch {
            
            //self.loggingText.text = "Unable to create Application Context"
            print("Unable to create Application Context")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureInitiallyView()
    {
        self.setBackGroundGradient()
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        
        do {            
            /**
             Removes all tokens from the cache for this application for the provided user
             - user:    The user to remove from the cache
             */
            
            try self.applicationContext.remove(self.applicationContext.users().first)
            //self.loggingText.text = ""
            print("Successfully sign-out")
            
            UserDefaults.standard.set(false, forKey: "status")
            SEViewControllerSwitcher.updateRootVC()

            
        } catch let error {
            //self.loggingText.text = "Received error signing user out: \(error)"
            print("Received error signing user out: \(error)")
        }
        
        
    }

}
