//
//  SEBaseViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SEBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackGroundGradient() -> Void
    {
        self.view.layer.insertSublayer(self.accessBackGroundGradientColor(), at: 0)
    }
    
    func accessBackGroundGradientColor() -> CAGradientLayer {

        let startingColorOfGradientOrange = UIColor(red: 237/255, green: 136/255, blue: 96/255, alpha: 1.0).cgColor
        let endingColorOFGradientPink = UIColor(red: 239/255, green: 103/255, blue: 141/255, alpha: 1.0).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame.size = self.view.frame.size
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y:1.0)

        gradient.colors = [startingColorOfGradientOrange , endingColorOFGradientPink]
        return gradient
    }
}
