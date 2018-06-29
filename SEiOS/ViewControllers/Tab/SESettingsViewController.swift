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

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tblSettings: UITableView!
    
    var applicationContext = MSALPublicClientApplication.init()
    let kClientID = "abf2827a-f496-450f-810f-e5c236360d62"
    let kAuthority = "https://login.microsoftonline.com/common/"

    let tableDastasource = ["Timezone", "Sign Out"]
    
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
        self.navigationController?.navigationBar.isHidden = true
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    
}

extension SESettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDastasource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingCell"
        var cell : SESettingsCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SESettingsCell?
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("SESettingsCell", owner: nil, options: nil)?[0] as? SESettingsCell
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        UITableViewCell.appearance().backgroundColor = .clear
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        cell?.selectionStyle = .none
        cell?.accessoryType = .none
        cell?.lblValue.isHidden = true
        cell?.lblTitile.text = tableDastasource[indexPath.row]
        if indexPath.row == 0 {
            cell?.lblValue.isHidden = false
            cell?.lblValue.text = timezone
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            do {
                /**
                 Removes all tokens from the cache for this application for the provided user
                 - user:    The user to remove from the cache
                 */
                
                try self.applicationContext.remove(self.applicationContext.users().first)
                //self.loggingText.text = ""
                print("Successfully sign-out")
                username = ""
                userProfilePicture = nil
                userDesignation = nil
                UserDefaults.standard.set(false, forKey: "status")
                SEViewControllerSwitcher.updateRootVC()                
            } catch let error {
                //self.loggingText.text = "Received error signing user out: \(error)"
                print("Received error signing user out: \(error)")
            }
            break
        case 0:
            let actionSheetController = UIAlertController(title: "Select timezone", message: nil, preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let utcActionButton = UIAlertAction(title: "UTC", style: .default) { action -> Void in
                timezone = "UTC"
                DispatchQueue.main.async {
                    self.tblSettings.reloadData()
                }
            }
            actionSheetController.addAction(utcActionButton)
            let indianActionButton = UIAlertAction(title: "India Standard Time", style: .default) { action -> Void in
                timezone = "India Standard Time"
                DispatchQueue.main.async {
                    self.tblSettings.reloadData()
                }
            }
            actionSheetController.addAction(indianActionButton)
            let cstActionButton = UIAlertAction(title: "CST", style: .default) { action -> Void in
                timezone = "Central Standard Time"
                DispatchQueue.main.async {
                    self.tblSettings.reloadData()
                }
            }
            actionSheetController.addAction(cstActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    
    
    
}
