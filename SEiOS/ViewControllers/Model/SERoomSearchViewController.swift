
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

struct  MeetingDetails
{
    var meetingDate : Date?
    var meetingStartTime : Date?
    var meetingEndTime : Date?
    var availMeetingRooms: [MeetingRoomDetails]?
}

protocol  SERoomDetailsDelegate{
    func showMeetingRoomDetails( meetingRoomDetails : MeetingRoomDetails, meetingStartTime:String, meetingEndTime : String, MeetingDate : String )
}

protocol SEFilteredRoomDetailsDelegate {
    func showFilteredMeetingRoomDetails(filteredMeetingRoomArray: [MeetingRoomDetails], meetingStartTime:String, meetingEndTime : String, MeetingDate:String)
}

extension SERoomSearchViewController:SEFilteredRoomDetailsDelegate
{
    func showFilteredMeetingRoomDetails(filteredMeetingRoomArray: [MeetingRoomDetails], meetingStartTime: String, meetingEndTime: String, MeetingDate:String) {

        print("===filteredMeetingRoomArray  \(filteredMeetingRoomArray)===")
        print("meetingStartTime : \(meetingStartTime), meetingEndTime : \(meetingEndTime), MeetingDate : \(MeetingDate) ")
        
        self.meetingStartTime = meetingStartTime
        self.meetingEndTime = meetingEndTime
        self.meetingDate = MeetingDate
        
        self.meetingRoomList = filteredMeetingRoomArray
        self.availableRoomsInfoTableView.reloadData()
    }
}

class SERoomSearchViewController: SEBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblBGFadeView: UIView!
    @IBOutlet weak var availableRoomsInfoTableView: UITableView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!

    var meetingRoomList = [MeetingRoomDetails]()
    var delegate : SERoomDetailsDelegate!
    var availableMeetingRoomsList = [MeetingDetails]()
   
    var meetingStartTime = ""
    var meetingEndTime = ""
    var meetingDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        
      //  Meeting Rooms Details Service Call
        self.serviceForMeetingRoom()
       // self.createMeetingRoomList()
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
        self.navigationController?.popViewController(animated: true)    }
    
    @IBAction func filterBarButton(_ sender: Any) {
        self.performSegue(withIdentifier: "roomSearch2Filter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "roomSearch2Filter" {
            
            let destinationVc = segue.destination as! SEFilterViewController
            destinationVc.delegate = self
            destinationVc.availMeetingRoomsList = self.availableMeetingRoomsList
        }
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
        navigationController?.popViewController(animated: true)
        self.delegate.showMeetingRoomDetails(meetingRoomDetails: self.meetingRoomList[indexPath.row], meetingStartTime: self.meetingStartTime, meetingEndTime: self.meetingEndTime, MeetingDate: self.meetingDate)
    }
    
    func createMeetingRoomList()
    {
        if let url = Bundle.main.url(forResource: "MeetingRoom", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    
                    let jsonDict = dictionary["meetingTimeSuggestions"] as! [[String : Any]]
                   
                    if let dictionary = object as? [String: AnyObject]
                    {
                        
                        let meetingTimeSuggestionsArray = dictionary["meetingTimeSuggestions"] as! [[String : Any]]
                        
                        for item in 0..<meetingTimeSuggestionsArray.count
                        {
                            let meetingTimeSuggestions = meetingTimeSuggestionsArray[item] as! [String : Any]
                            
                            let meetingRoomArray =  meetingTimeSuggestions["locations"] as! [[String : Any]]
                            var availMeetigRooms = [MeetingRoomDetails]()
                            for room in meetingRoomArray {
                                //generate meeting room list
                                var meetingRoom = MeetingRoomDetails()
                                meetingRoom.meetingRoomName = room["displayName"] as! String
                                meetingRoom.meetingRoomCapacity = meetingTimeSuggestions["confidence"] as! Int
                                meetingRoom.availabilityStaus = true
                                availMeetigRooms.append(meetingRoom)
                            }
                            let meetingSlot = meetingTimeSuggestions["meetingTimeSlot"]  as! [String : Any]
                            let startSlot  = meetingSlot["start"] as! [String : Any]
                            let endSlot  = meetingSlot["end"] as! [String : Any]
                            let startDateTime = startSlot["dateTime"] as! String
                            let endDateTime = endSlot["dateTime"] as! String
                            
                            
                            var meetingDetails = MeetingDetails()
                            meetingDetails.meetingDate = meetingDateAndTime(dateTime: startDateTime).meetingDate
                            meetingDetails.meetingStartTime = meetingDateAndTime(dateTime: startDateTime).meetingTime
                            meetingDetails.meetingEndTime = meetingDateAndTime(dateTime: endDateTime).meetingTime
                            meetingDetails.availMeetingRooms = availMeetigRooms
                            
                            self.availableMeetingRoomsList.append(meetingDetails)
                        }
                        
                        self.meetingRoomList = self.availableMeetingRoomsList[0].availMeetingRooms!

                    }
                    
                  //  print(" self.availableMeetingRoomsList : \( self.availableMeetingRoomsList)")
                    
                    self.availableRoomsInfoTableView.reloadData()

                }
            } catch {
            }
        }
        
    }
    
   
    func meetingDateAndTime( dateTime: String) -> (meetingDate:Date, meetingTime:Date)
    {
        let _date = formattedDateFromString(dateString: dateTime, withFormat: "dd-MM-yyy")
        let _time = formattedDateFromString(dateString: dateTime, withFormat: "HH:mm:ss a")
        print("date : \(_date) time : \(_time)")
        return(_date!, _time!)
    }
    func formattedDateFromString(dateString: String, withFormat format: String) -> Date? {
        
        let dateInputFormatter = DateFormatter()
        dateInputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssssss"
        dateInputFormatter.timeZone =  TimeZone.current

        if let formattedDate = dateInputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            let dateString = outputFormatter.string(from: formattedDate)
            return outputFormatter.date(from: dateString)
        }
        return nil
    }
    
    func serviceForMeetingRoom()
    {
        
        self.startLoading()
        let urlString = SEWebserviceClient.filterMeetingURL
        
        let headerDict = [
            "Authorization" : "Bearer \(SEStoreSharedManager.sharedInstance.accessToken)",
            "Content-Type" : "application/json"
        ]
        
        print("headerDict : \(headerDict)")
        
        
        let startDict: [String: String] = ["dateTime": "2018-06-22T17:00:00",
            "timeZone": "UTC"]
        
        let endDict: [String: String] = ["dateTime": "2018-06-22T17:30:00",
            "timeZone": "UTC"]
        
        let param: Parameters = ["timeConstraint":[
            "activityDomain": "unrestricted",
            "timeslots": [
                [
                    "start":startDict,
                    "end":endDict
                ]
            ]
            ]
        ]
        
        
        
        print("param :\(param)")
        
        Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headerDict).responseJSON { (response:DataResponse<Any>) in
            
            switch (response.result)
            {
            case .success(_):
                print("Success")
                self.stopLoading()
                if response.result.value != nil{
                    do {
                        let object = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments)
                        
                       
                        if let dictionary = object as? [String: AnyObject] {
                            print("dictionary : \(dictionary)")
                            let jsonDict = dictionary["meetingTimeSuggestions"] as? [[String : Any]]
                            if jsonDict != nil {
                                
                                let meetingTimeSuggestionsArray = dictionary["meetingTimeSuggestions"] as! [[String : Any]]
                                
                                for item in 0..<meetingTimeSuggestionsArray.count
                                {
                                    let meetingTimeSuggestions = meetingTimeSuggestionsArray[item] as! [String : Any]
                                    
                                    let meetingRoomArray =  meetingTimeSuggestions["locations"] as! [[String : Any]]
                                    var availMeetigRooms = [MeetingRoomDetails]()
                                    for room in meetingRoomArray {
                                        //generate meeting room list
                                        var meetingRoom = MeetingRoomDetails()
                                        meetingRoom.meetingRoomName = room["displayName"] as! String
                                        meetingRoom.meetingRoomCapacity = meetingTimeSuggestions["confidence"] as! Int
                                        meetingRoom.availabilityStaus = true
                                        availMeetigRooms.append(meetingRoom)
                                    }
                                    let meetingSlot = meetingTimeSuggestions["meetingTimeSlot"]  as! [String : Any]
                                    let startSlot  = meetingSlot["start"] as! [String : Any]
                                    let endSlot  = meetingSlot["end"] as! [String : Any]
                                    let startDateTime = startSlot["dateTime"] as! String
                                    let endDateTime = endSlot["dateTime"] as! String
                                    
                                    var meetingDetails = MeetingDetails()
                                    meetingDetails.meetingDate = self.meetingDateAndTime(dateTime: startDateTime).meetingDate
                                    meetingDetails.meetingStartTime = self.meetingDateAndTime(dateTime: startDateTime).meetingTime
                                    meetingDetails.meetingEndTime = self.meetingDateAndTime(dateTime: endDateTime).meetingTime
                                    meetingDetails.availMeetingRooms = availMeetigRooms
                                    
                                    self.availableMeetingRoomsList.append(meetingDetails)
                                }
                                
                                self.meetingRoomList = self.availableMeetingRoomsList[0].availMeetingRooms!
                                self.availableRoomsInfoTableView.reloadData()
                            }
                            
                        }
                    } catch {
                    }
                }
                
            case .failure(_) :
                self.stopLoading()
                print("Failure")
                
            }
            
            
        }
    }
}

