//
//  SEBaseViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SEBaseViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView()
    var sevenElevenContainer: UIView = UIView()
    var sevenElevenLoadingView: UIView = UIView()
    var sevenElevenActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    
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
    
    
    
    
    // ----------------------------------------------------------------------------------------
    // MARK: - Adding loader animation
    // ----------------------------------------------------------------------------------------
    
    public func startLoading() {
        
        self.hideActivityIndicator(uiView: self.view)
        self.showActivityIndicator(uiView: self.view)
    }
    
    public func stopLoading() {
        self.hideActivityIndicator(uiView: self.view)
    }
    
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        sevenElevenContainer.removeFromSuperview()
    }
    
    
    
    // ----------------------------------------------------------------------------------------
    // MARK: - Start customized activity indicator
    // ----------------------------------------------------------------------------------------
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    
    func showActivityIndicator(uiView: UIView) {
        sevenElevenContainer.frame = uiView.frame
        sevenElevenContainer.center = uiView.center
        sevenElevenContainer.backgroundColor = UIColor.clear //UIColorFromHexValue(rgbValue: 0xffffff, alpha: 0.3)
        
        sevenElevenLoadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        sevenElevenLoadingView.center = uiView.center
        //sevenElevenLoadingView.backgroundColor = UIColorFromHexValue(rgbValue: 0x444444, alpha: 0.7)
        sevenElevenLoadingView.clipsToBounds = true
        sevenElevenLoadingView.layer.cornerRadius = 10
        
        sevenElevenActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        sevenElevenActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        sevenElevenActivityIndicator.center = CGPoint(x: sevenElevenLoadingView.frame.size.width / 2, y: sevenElevenLoadingView.frame.size.height / 2)
        
        sevenElevenLoadingView.addSubview(sevenElevenActivityIndicator)
        sevenElevenContainer.addSubview(sevenElevenLoadingView)
        UIApplication.shared.delegate?.window??.addSubview(sevenElevenContainer)
        sevenElevenActivityIndicator.startAnimating()
    }
    
    
    
    
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

