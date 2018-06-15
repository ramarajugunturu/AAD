//
//  SECreateEventViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire

class SECreateEventViewController: SEBaseViewController, SERoomDetailsDelegate, UpdateAttendeeListDelegate {
    
    func showMeetingRoomDetails(meetingRoomDetails: MeetingRoomDetails) {
        self.meetingRoomDetails = meetingRoomDetails
        self.tblCreateEvent.reloadData()
    }
    
    
    //let roomTitles_Array  = ["Jupiter", "Venus", "America", "Singapoor"]
    
    let eventHeadingArray = [["name": "Event Title", "image": "icon_event_title"],
                             ["name": "Location", "image": "icon_location"],
                             ["name": "Select People", "image": "icon_people"],
                             ["name": "Select Date", "image": "icon_date"],
                             ["name": "All-day Event", "image": ""],
                             ["name": "Select Time", "image": "icon_time"],
                             ["name": "Repeat", "image": "icon_repeat"],
                             ["name": "Alert", "image": "icon_alert"],
                             ["name": "Description", "image": "icon_description"]]
    
    
    @IBOutlet weak var tblCreateEvent: UITableView!
    @IBOutlet weak var tblBGFadeView: UIView!
    var meetingRoomDetails = MeetingRoomDetails()
    var attendeeName : String! = ""
    var webServiceAPI = SEWebServiceAPI()
    
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
        self.tblCreateEvent.layer.cornerRadius = 10.0
        self.tblCreateEvent.backgroundColor = UIColor.clear
        tblCreateEvent.delegate = self
        tblCreateEvent.dataSource = self
        tblCreateEvent.showsHorizontalScrollIndicator = false
        tblCreateEvent.showsVerticalScrollIndicator = false
        self.tblBGFadeView.layer.cornerRadius = 10.0
    }
    
    func updateAttendeesList(list: Array<Any>) {
        attendeeName = ""
        if list.count != 0 {
            for item in list {
                let t = item as! SEUserModel
                attendeeName.append("\(t.displayName!) ")
            }
            tblCreateEvent.reloadData()
        }
    }
}

extension SECreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventHeadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CreateEventCell"
        var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventTableViewCell?
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("SECreateEventTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventTableViewCell
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        UITableViewCell.appearance().backgroundColor = .clear
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.layer.backgroundColor = UIColor.clear.cgColor
        cell?.selectionStyle = .none
        
        let item = eventHeadingArray[indexPath.row]
        let titleStr = item["name"]
        let titleImage = item["image"]
        cell?.imageView?.image = UIImage(named: titleImage!)
        cell?.lblTitle.text = titleStr
        
        
        
        cell?.txtField.isHidden = false
        var placeHolderText  = ""
        switch indexPath.row {
        case 0:
            placeHolderText = "Write your title here"
        case 1:
            
            if self.meetingRoomDetails.meetingRoomName != ""
            {
                cell?.txtField.text = self.meetingRoomDetails.meetingRoomName
                cell?.txtField.isUserInteractionEnabled = false
            }
            else
            {
                placeHolderText = "Write your title here"
                cell?.txtField.isUserInteractionEnabled = true
            }
            
        case 2:
            if attendeeName == ""{
                cell?.txtField.text = ""
                placeHolderText = "Tap to add people from contacts"
            }
            else{
                cell?.txtField.isUserInteractionEnabled = false
                cell?.txtField.text = attendeeName
            }
            
            
        case 3:
            placeHolderText = "Tuesday, 5 Jun"
        case 4:
            cell?.txtField.isHidden = true
            break
        case 5:
            placeHolderText = "10:00 AM"
        case 6:
            placeHolderText = "Never"
        case 7:
            placeHolderText = "15 minutes before"
        case 8:
            placeHolderText = "Write your description here"
            
        default:
            break
        }
        
        
        var placeHolder = NSMutableAttributedString()
        // Set the Font
        placeHolder = NSMutableAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 12)])
        // Set the color
        placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range:NSRange(location:0, length:placeHolderText.count))
        
        
        // Add attribute
        cell?.txtField.attributedPlaceholder = placeHolder
        
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        footerView.backgroundColor = UIColor.clear
        
        let btnCreateEvent = UIButton.init(type: .custom)
        btnCreateEvent.frame = CGRect(x: 0, y: 0, width: self.tblCreateEvent.frame.size.width, height: 50)
        btnCreateEvent.setTitle("CREATE EVENT", for: .normal)
        btnCreateEvent.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btnCreateEvent.addTarget(self, action: #selector(createEventAction), for: .touchUpInside)
        btnCreateEvent.setTitleColor(UIColor.white, for: .normal)
        btnCreateEvent.backgroundColor = UIColor(red: 95/255, green: 93/255, blue: 166/255, alpha: 1.0)
        footerView.addSubview(btnCreateEvent)
        return footerView
        
    }
    
    @objc func createEventAction() {
        print("Add event!!")
        /*
         if currentReachabilityStatus == .notReachable {
         self.handleWebServicePopup(messageStr: AuthenticatedErrorMessages.NetworkAlert.NOT_REACHABLE)
         return
         }
         
         self.startMerlinLoading()
         */
        
        self.startLoading()
        let url = SEWebserviceClient.eventURL
        
        let bodyDict: [String: String] = ["contentType": "HTML",
                                          "content": "Let's kick-start this event planning!"]
        
        let startDict: [String: String] = ["dateTime": "2018-06-15T22:00:00",
                                           "timeZone": "India Standard Time"]
        
        let endDict: [String: String] = ["dateTime": "2018-06-15T23:00:00",
                                         "timeZone": "India Standard Time"]
        
        
        var attendeesArray = [[String: Any]]()
        
        let emailDetailsDict: [String: String] = ["address": "Harish.Rathuri@infovisionlabs.com",
                                                  "name": "Harish Rathuri"]
        
        let emailAddressDict: [String: Any] = ["emailAddress": emailDetailsDict,
                                               "type": "Required"]
        
        attendeesArray.append(emailAddressDict)
        
        let locationDict: [String: String] = ["displayName": "Estonia",
                                              "locationType": "conferenceRoom"]
        
        
        var locationsArray = [[String: Any]]()
        let locationsDict: [String: String] = ["displayName": "Estonia"]
        locationsArray.append(locationsDict)
        
        let parameters : Parameters = ["subject": "Plan summer company picnic",
                                       "body": bodyDict,
                                       "start": startDict,
                                       "end": endDict,
                                       "attendees": attendeesArray,
                                       "location": locationDict,
                                       "locations": locationsArray]
        
        
        webServiceAPI.createEventAPI(url: url, parameters: parameters, onSuccess: { (response) in
            print("createEventAPI.createEventAPI")
            self.stopLoading()
            if response is [String : Any]
            {
                
                
                
            }
            else
            {
                //self.handleWebServicePopup(messageStr: response as! String)
            }
        }, onError:{ error in
            print("Error Results:\(error)")
            self.stopLoading()
        })

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "event2RoomSearch", sender: nil)
            break
        case 2:
            self.performSegue(withIdentifier: "addAttendee", sender: nil)
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "event2RoomSearch") {
            let vc = segue.destination as! SERoomSearchViewController
            vc.delegate = self
        }
        if (segue.identifier == "addAttendee") {
            let vc = segue.destination as! SEAttendeesListViewController
            vc.delegate = self
        }
    }
    
    //Check commit
    
}



