//
//  SESettingsViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 14/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SESettingsViewController: SEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        // Do any additional setup after loading the view.
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
        UserDefaults.standard.set(false, forKey: "status")
        SEViewControllerSwitcher.updateRootVC()
    }

}
