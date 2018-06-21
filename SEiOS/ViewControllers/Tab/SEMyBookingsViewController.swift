//
//  SEMyBookingsViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SEMyBookingsViewController: SEBaseViewController {

    @IBOutlet weak var tblUpcomingMeetings: UITableView!
    @IBOutlet weak var lblMeetingDetails: UILabel!
    @IBOutlet weak var lblUserDesignation: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var viewMeetingDetails: UIView!
    
    var webServiceAPI = SEWebServiceAPI()
    var tableDataSource = [SEMyMeetingModel]()
    
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
        let tableCellNIB = UINib(nibName: "SEMyMeetingsCell", bundle: nil)
        self.tblUpcomingMeetings.register(tableCellNIB, forCellReuseIdentifier: "MyMeetingDetails")
        self.navigationController?.navigationBar.isHidden = true
        getMyMeeting()
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.height/2.0
        imgProfilePic.clipsToBounds = true
        viewUserInfo.layer.cornerRadius = 10
        viewUserInfo.clipsToBounds = true
        viewMeetingDetails.layer.cornerRadius = 10
        viewMeetingDetails.clipsToBounds = true
        
        imgProfilePic.image = UIImage(named: "icon_people")
        lblUsername.text = username
        lblUserDesignation.text = "Software Engineer"
        lblMeetingDetails.text = "Welcome back, \(username!)!\nYou have a meeting today at 11:30 AM in Jupiter. You will be joined by 3 people"
    }
    
    func getMyMeeting() {
        self.startLoading()
        let url = SEWebserviceClient.myMeetingListURL
        webServiceAPI.getMyMeetingList(url: url, onSuccess: { (response) in
            if response is [SEMyMeetingModel]{
                self.tableDataSource = response as! [SEMyMeetingModel]
                self.tblUpcomingMeetings.reloadData()
                self.stopLoading()
            }else{
                print("KUCH TO HO GYA")
                self.stopLoading()
            }
        }) { (error) in
            print("ERROR")
            self.stopLoading()
        }
    }
    
}

extension SEMyBookingsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMeetingDetails", for: indexPath) as! SEMyMeetingsCell
        cell.selectionStyle = .none
        let modObj = tableDataSource[indexPath.row]
        cell.lblDate.text = modObj.date
        cell.lblTime.text = modObj.time
        cell.lblTitle.text = modObj.subject
        cell.lblLocation.text = "Meeting room: \(modObj.location!)"
        
        return cell
    }
    
    
}
