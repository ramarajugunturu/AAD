//
//  SEFilterViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SEFilterViewController: SEBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureInitiallyView(){
        self.setBackGroundGradient()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
