//
//  SEMainViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 04/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import MSAL

class SEMainViewController: SEBaseViewController, URLSessionDelegate {
    
    // Update the below to your client ID you received in the portal. The below is for running the demo only
    
    let kClientID = "abf2827a-f496-450f-810f-e5c236360d62"
    
    // These settings you don't need to edit unless you wish to attempt deeper scenarios with the app.
    
    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
    let kAuthority = "https://login.microsoftonline.com/common/"
    
    var accessToken = String()
    var applicationContext = MSALPublicClientApplication.init()
    
    
    @IBOutlet weak var signoutButton: UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureInitiallyView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.accessToken.isEmpty {
            
            signoutButton.isEnabled = false;
            signoutButton.alpha = 0.2
            
        }
    }
    

    @IBAction func callSignInButton(_ sender: UIButton) {
        
        
        do {
            
            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.
            
            
            if  try self.applicationContext.users().isEmpty {
                throw NSError.init(domain: "MSALErrorDomain", code: MSALErrorCode.interactionRequired.rawValue, userInfo: nil)
            } else {
                
                /**
                 
                 Acquire a token for an existing user silently
                 
                 - forScopes: Permissions you want included in the access token received
                 in the result in the completionBlock. Not all scopes are
                 gauranteed to be included in the access token returned.
                 - User: A user object that we retrieved from the application object before that the
                 authentication flow will be locked down to.
                 - completionBlock: The completion block that will be called when the authentication
                 flow completes, or encounters an error.
                 */
                
                try self.applicationContext.acquireTokenSilent(forScopes: self.kScopes, user: applicationContext.users().first) { (result, error) in
                    
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        //self.loggingText.text = "Refreshed Access token is \(self.accessToken)"
                        print("Refreshed Access token is \(self.accessToken)")
                        
                        self.signoutButton.isEnabled = true;
                        self.signoutButton.alpha = 1.0
                        self.getContentWithToken()
                        
                    } else {
                        //self.loggingText.text = "Could not acquire token silently: \(error ?? "No error informarion" as! Error)"
                        print("Could not acquire token silently: \(error ?? "No error informarion" as! Error)")
                    }
                }
            }
        }  catch let error as NSError {
            
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            
            if error.code == MSALErrorCode.interactionRequired.rawValue {
                
                self.applicationContext.acquireToken(forScopes: self.kScopes) { (result, error) in
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        //self.loggingText.text = "Access token is \(self.accessToken)"
                        print("Access token is \(self.accessToken)")
                        self.signoutButton.isEnabled = true;
                        self.signoutButton.alpha = 1.0
                        self.getContentWithToken()
                        
                    } else  {
                        //self.loggingText.text = "Could not acquire token: \(error ?? "No error informarion" as! Error)"
                        
                        print("Could not acquire token: \(error ?? "No error informarion" as! Error)")
                    }
                }
                
            }
            
        } catch {
            
            // This is the catch all error.
            
            //self.loggingText.text = "Unable to acquire token. Got error: \(error)"
            
            print("Unable to acquire token. Got error: \(error)")
            
        }
    }
    
    
    /**
     This button will invoke the call to the Microsoft Graph API. It uses the
     built in Swift libraries to create a connection.
     Pay attention to the error case below. It shows you how to
     detect a `UserInteractionRequired` Error case and present the `acquireToken()`
     method again for the user to sign in. This usually happens if
     the Refresh Token has expired or the user has changed their
     password.
     
     */
    
    func getContentWithToken() {
        
        let sessionConfig = URLSessionConfiguration.default
        
        // Specify the Graph API endpoint
        let url = URL(string: kGraphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        let urlSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
        
        urlSession.dataTask(with: request) { data, response, error in
            
            let result = try? JSONSerialization.jsonObject(with: data!, options: [])
            if result != nil {
                
                //self.loggingText.text = result.debugDescription
                
                print(result.debugDescription)
            }
            }.resume()
    }
    
    
    /**
     This button will invoke the signout APIs to clear the token cache.
     
     */
    
    @IBAction func signoutButton(_ sender: UIButton) {
        print("signoutButton")
        self.performSegue(withIdentifier: "mySETabbarControllerID", sender: nil)
        
        /*
        do {
            
            /**
             Removes all tokens from the cache for this application for the provided user
             
             - user:    The user to remove from the cache
             */
            
            try self.applicationContext.remove(self.applicationContext.users().first)
            //self.loggingText.text = ""
            print("Successfully sign-out")
            self.signoutButton.isEnabled = false;
            signoutButton.alpha = 0.2
            
        } catch let error {
            //self.loggingText.text = "Received error signing user out: \(error)"
            print("Received error signing user out: \(error)")
        }
        */
    }
    
    
    func configureInitiallyView()
    {
         self.setBackGroundGradient()
    }
    
}
