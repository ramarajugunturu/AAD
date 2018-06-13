//
//  SERoomSearchViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SERoomSearchViewController: SEBaseViewController {

    @IBOutlet weak var tblBGFadeView: UIView!
    
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
        self.tblBGFadeView.layer.cornerRadius = 10.0
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "roomSearch2Filter", sender: nil)
    }
}
