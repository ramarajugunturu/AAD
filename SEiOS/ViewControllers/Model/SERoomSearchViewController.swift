//
//  SERoomSearchViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SERoomSearchViewController: SEBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblBGFadeView: UIView!
    @IBOutlet weak var availableRoomsInfoTableView: UITableView!
    
    let roomTitles_Array = ["Jupiter", "Venus", "America", "Singapoor"]
    let roomCapacity_Array = ["4", "5", "17", "88"]
    
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
        self.availableRoomsInfoTableView.backgroundColor = UIColor.clear
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "roomSearch2Filter", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomTitles_Array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "roomSearchInfoCustomCellId"
        var cell : SERoomSearchTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SERoomSearchTableViewCell?
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("SERoomSearchTableViewCell", owner: nil, options: nil)?[0] as? SERoomSearchTableViewCell
            //cell?.confRoomTitleLbl.textColor = UIColor.lightGray
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            
            //cell?.accessoryView = UIImageView(image: UIImage(named: "arrow_right_purple"))
        }
        UITableViewCell.appearance().backgroundColor = .clear
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        cell?.selectionStyle = .none
        //let row = indexPath.row
        cell?.confRoomImg.layer.cornerRadius = 10.0
        cell?.confRoomTitleLbl.text = "\(roomTitles_Array[(indexPath as NSIndexPath).row])"
        cell?.roomCapacityCount.text = "Capacity: \(roomCapacity_Array[(indexPath as NSIndexPath).row]) People"

        return cell!
        
    }
}

