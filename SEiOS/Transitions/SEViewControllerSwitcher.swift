//
//  SEViewControllerSwitcher.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 14/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

class SEViewControllerSwitcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        
        print("VC Switch Status:\(status)")
        
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarvc") as! SEMianTabBarViewController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as! SEMainViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    
    }
}
