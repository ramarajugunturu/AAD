
//
//  SERoomSearchViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire

struct MeetingRoomDetails
{
    var meetingRoomName = ""
    var meetingRoomCapacity = 0
    var availabilityStaus = true
}

protocol  SERoomDetailsDelegate{
    func showMeetingRoomDetails( meetingRoomDetails : MeetingRoomDetails)
}

class SERoomSearchViewController: SEBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblBGFadeView: UIView!
    @IBOutlet weak var availableRoomsInfoTableView: UITableView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!

    var meetingRoomList = [MeetingRoomDetails]()
    var delegate : SERoomDetailsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        
      //  Meeting Rooms Details Service Call
        self.serviceForMeetingRoom()
      //    self.createMeetingRoomList()
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
    
    @IBAction func filterBarButton(_ sender: Any) {
        self.performSegue(withIdentifier: "roomSearch2Filter", sender: nil)

    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetingRoomList.count
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
        
        let meetingRoom = self.meetingRoomList[indexPath.row]
        cell?.confRoomTitleLbl.text = meetingRoom.meetingRoomName
        cell?.roomCapacityCount.text = "Capacity: \(meetingRoom.meetingRoomCapacity) People"
        cell?.roomAvailabilityStatus.text = meetingRoom.availabilityStaus ? "Available" : "Not Available"
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        self.delegate.showMeetingRoomDetails(meetingRoomDetails: self.meetingRoomList[indexPath.row])
    }
    
    
    
    func createMeetingRoomList()
    {
        if let url = Bundle.main.url(forResource: "MeetingRoom", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    
                    
                    let jsonDict = dictionary["meetingTimeSuggestions"] as! [[String : Any]]
                    let meetingTimeSuggestions = jsonDict[0] as! [String : Any]
                    let meetingRoomArray =  meetingTimeSuggestions["locations"] as! [[String : Any]]
                    
                    for room in meetingRoomArray {
                        var meetingRoom = MeetingRoomDetails()
                        meetingRoom.meetingRoomName = room["displayName"] as! String
                        meetingRoom.meetingRoomCapacity = meetingTimeSuggestions["confidence"] as! Int
                        meetingRoom.availabilityStaus = true
                        self.meetingRoomList.append(meetingRoom)
                    }
                    
                }
            } catch {
            }
        }
        
    }
    
    func serviceForMeetingRoom()
    {
        let urlString = "https://graph.microsoft.com/v1.0/me/findMeetingTimes"
        
        let headerDict = [
            "Authorization" : "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)",
            "Content-Type" : "application/json"
        ]
        
        print("headerDict : \(headerDict)")
        
        Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headerDict).responseJSON { (response:DataResponse<Any>) in
            
            switch (response.result)
            {
            case .success(_):
                print("Success")
                if response.result.value != nil{
                    do {
                        let object = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                        
                       
                        if let dictionary = object as? [String: AnyObject] {
                            print("dictionary : \(dictionary)")
                            let jsonDict = dictionary["meetingTimeSuggestions"] as? [[String : Any]]
                            if jsonDict != nil {
                                
                                let meetingTimeSuggestions = jsonDict![0] as? [String : Any]
                                let meetingRoomArray =  meetingTimeSuggestions!["locations"] as? [[String : Any]]
                                for room in meetingRoomArray! {
                                    var meetingRoom = MeetingRoomDetails()
                                    meetingRoom.meetingRoomName = room["displayName"] as! String
                                    meetingRoom.meetingRoomCapacity = meetingTimeSuggestions!["confidence"] as! Int
                                    meetingRoom.availabilityStaus = true
                                    self.meetingRoomList.append(meetingRoom)
                                }
                                self.availableRoomsInfoTableView.reloadData()
                            }
                            
                        }
                    } catch {
                    }
                }
                
            case .failure(_) :
                print("Failure")
                
                
            }
            
            
        }
    }
}

