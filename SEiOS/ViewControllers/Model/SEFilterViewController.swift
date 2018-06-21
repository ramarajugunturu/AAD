//
//  SEFilterViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire

extension UIButton{
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension UIViewController
{
    
    func addAlert(title:String, alertMsg:String)
    {
        let alert = UIAlertController(title: title, message: alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension String
{
    func getPlaceholderString()-> NSMutableAttributedString
    {
        var placeHolder = NSMutableAttributedString()
        placeHolder = NSMutableAttributedString(string: self, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 12)])
        placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range:NSRange(location:0, length:self.count))
        return placeHolder
    }
   
}

class SEFilterViewController: SEBaseViewController {
    
    
    @IBOutlet weak var tblBGFadeView: UIView!
    @IBOutlet weak var tblFilterCriteria: UITableView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    var delegate :SEFilteredRoomDetailsDelegate!
    
    let headingArray = [
        ["name": "Floor", "image": "icon_location"],
        ["name": "Capacity", "image": "icon_people"],
        ["name": "Available Date", "image": "icon_date"],
        ["name": "Available Time", "image": "icon_time"]
    ]
    var datePickerView:UIDatePicker = UIDatePicker()
    var selectedDate = ""
    
    var startMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var selectedStartMeetingTime = ""
    
    var endMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var selectedEndMeetingTime = ""
    
    var capacityPicker = UIPickerView()
    var selectedCapacity = ""
    var selectedIndexCapacityPicker = 0
    
    var locationPicker = UIPickerView()
    var selectedLocation = ""
    var selectedIndexLocationPicker = 0
    
    var endMeetingTimeForService = ""
    var startMeetingTimeForService = ""
    var dateForService = ""
    
    var capacityArray = ["1-5 people", "1-10 people", "1-20 people", "1-30 people","1-50 people","1-100 people"]
    var locationArray = ["1st Floor", "2nd Floor", "3rd Floor", "4th Floor", "5th Floor"]
    var availMeetingRoomsList = [MeetingDetails]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitiallyView()
        // Do any additional setup after loading the view.
        print("availMeetingRoomsList : \(availMeetingRoomsList)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureInitiallyView()
    {
        self.setBackGroundGradient()
        self.tblBGFadeView.layer.cornerRadius = 10.0
        self.tblFilterCriteria.backgroundColor = UIColor.clear
        
        OperationQueue.main.addOperation {
            self.btnApplyFilter.backgroundColor = UIColor(red: 95/255, green: 93/255, blue: 166/255, alpha: 1.0)
            self.btnApplyFilter.roundCorners([.bottomRight, .bottomLeft], radius: 10)
        }
        capacityPicker.dataSource = self
        capacityPicker.delegate = self
        capacityPicker.tag = 100
        
        locationPicker.dataSource = self
        locationPicker.delegate = self
        locationPicker.tag = 200
    }
    
    @IBAction func btnBack(_ sender: Any) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnApplyFilter(_ sender: Any) {

        if(self.selectedDate == "")
        {
           self.addAlert(title: "", alertMsg: "Please select Date")
        }
        else if(startMeetingTimeForService == "")
        {
            self.addAlert(title: "", alertMsg: "Please select Time")
        }
        else{
            self.filterservice()
            
        }
    }
    
    var webServiceAPI = SEWebServiceAPI()
    
    func filterservice()
    {
        let startDict: [String: String] = ["dateTime": "\(selectedDate)T\(startMeetingTimeForService):00",
            "timeZone": "UTC"]
        
        let endDict: [String: String] = ["dateTime": "\(selectedDate)T\(endMeetingTimeForService):00",
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
        
         self.startLoading()
        let url = SEWebserviceClient.filterMeetingURL
       
        webServiceAPI.filterMeetingSlots(url: url, parameters: param, onSuccess: { (response) in
             self.stopLoading()
            if response is [String : Any]
            {
                let responseDict = response as! Dictionary<String,Any>
                let meetingTimeSuggestionsArray = responseDict["meetingTimeSuggestions"] as! Array<Any>
                var availMeetigRooms = [MeetingRoomDetails]()
                for item in 0..<meetingTimeSuggestionsArray.count
                {
                    let meetingTimeSuggestions = meetingTimeSuggestionsArray[item] as! [String : Any]

                    let meetingRoomArray =  meetingTimeSuggestions["locations"] as! [[String : Any]]
                   // var availMeetigRooms = [MeetingRoomDetails]()
                    for room in meetingRoomArray {
                        //generate meeting room list
                        var meetingRoom = MeetingRoomDetails()
                        meetingRoom.meetingRoomName = room["displayName"] as! String
                        meetingRoom.meetingRoomCapacity = meetingTimeSuggestions["confidence"] as! Int
                        meetingRoom.availabilityStaus = true
                        availMeetigRooms.append(meetingRoom)
                    }
                    print("availMeetigRooms :\(availMeetigRooms)")
                }
                
                if(availMeetigRooms.count > 0)
                {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate.showFilteredMeetingRoomDetails(filteredMeetingRoomArray: availMeetigRooms, meetingStartTime: self.selectedStartMeetingTime, meetingEndTime: self.selectedEndMeetingTime, MeetingDate: self.selectedDate )
                }
                else{
                    
                    self.addAlert(title: "", alertMsg: "No Suggestion found.")
                }
            }
            else
            {
                print("response :Problem")
            }
            
        }) { (error) in
            print("Error Results:\(error)")
            self.stopLoading()
        }
    }
    
}

extension SEFilterViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
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
        
        let item = headingArray[indexPath.row]
        let titleStr = item["name"]
        let titleImage = item["image"]
        cell?.imageView?.image = UIImage(named: titleImage!)
        cell?.lblTitle.text = titleStr
        OperationQueue.main.addOperation {
            if(indexPath.row == 3)
            {
                cell?.txtEndMeetingTime.isHidden = false
                cell?.txtStartMeetingTime.isHidden = false
                cell?.lblMeetingInterval.isHidden = false
                cell?.lblLine.isHidden = true
            }
            else
            {
                cell?.txtEndMeetingTime.isHidden = true
                cell?.txtStartMeetingTime.isHidden = true
                cell?.lblMeetingInterval.isHidden = true
                cell?.lblLine.isHidden = false
            }
        }
        
        switch indexPath.row {
        case  0:
            // location Picker
            var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.doneLocationPicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            cell?.txtField.tag = 1001
            cell?.txtField.inputView = locationPicker
            cell?.txtField.inputAccessoryView = toolbar
            
            if selectedLocation != ""
            {
                cell?.txtField.text = selectedLocation
                
            }else{
                let placeholderString = "Please select floor"
                cell?.txtField.attributedPlaceholder = placeholderString.getPlaceholderString()
            }
            
        case  1:
            // capacity Picker
            var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.doneCapacityPicker(sender:)), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            cell?.txtField.tag = 1002
            cell?.txtField.inputView = capacityPicker
            cell?.txtField.inputAccessoryView = toolbar
            
            if selectedCapacity != ""
            {
                cell?.txtField.text = selectedCapacity
                
            }else{
                let placeholderString = "Please select capacity"
                cell?.txtField.attributedPlaceholder = placeholderString.getPlaceholderString()
            }
            
            
        case  2:
            
            // date Picker
            datePickerView.datePickerMode = UIDatePickerMode.date
            datePickerView.minimumDate = Date()

            cell?.txtField.inputView = datePickerView
            cell?.txtField.tag = 1003
            
            let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.doneDatePicker(sender:)), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            
            cell?.txtField.inputAccessoryView = toolBar
            if selectedDate != ""
            {
                cell?.txtField.text = "\(selectedDate)"
                
            }else{
                let placeholderString = "Please select date"
                cell?.txtField.attributedPlaceholder = placeholderString.getPlaceholderString()
                
            }
            
        case  3:
            
            // startTime Picker
            var startTimetoolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.doneStartTimePicker(sender:)), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            cell?.txtField.tag = 1004
            
            startMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            startMeetingTimePickerView.minuteInterval = 30
            cell?.txtStartMeetingTime.inputView = startMeetingTimePickerView
            cell?.txtStartMeetingTime.inputAccessoryView = startTimetoolBar
            
            if selectedStartMeetingTime != ""
            {
                cell?.txtStartMeetingTime.text = "\(selectedStartMeetingTime)"
            }else{
                let placeholderString = "Start Time"
                cell?.txtStartMeetingTime.attributedPlaceholder = placeholderString.getPlaceholderString()
                
            }
            
            
            
            // endTime Picker
            var endTimetoolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.doneEndTimePicker(sender:)), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            endMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            endMeetingTimePickerView.minuteInterval = 30
            // cell?.txtEndMeetingTime.inputView = endMeetingTimePickerView
           // cell?.txtEndMeetingTime.inputAccessoryView = endTimetoolBar
            cell?.txtEndMeetingTime.isUserInteractionEnabled = false
            if selectedEndMeetingTime != ""
            {
                cell?.txtEndMeetingTime.text = "\(selectedEndMeetingTime)"
            }else{
                let placeholderString = "End Time"
                cell?.txtEndMeetingTime.attributedPlaceholder = placeholderString.getPlaceholderString()
            }
            
            
        default:
            break
        }
        
        return cell!
    }
    
    
    //ToolBar Methods
    @objc func doneLocationPicker(sender: Any) {
        
        self.selectedLocation = locationArray[selectedIndexLocationPicker]
        tblFilterCriteria.reloadData()
        view.endEditing(true)
    }
    
    @objc func doneCapacityPicker(sender: Any) {
        
        self.selectedCapacity = capacityArray[selectedIndexCapacityPicker]
        tblFilterCriteria.reloadData()
        view.endEditing(true)
    }
    
    @objc func doneDatePicker(sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.selectedDate = dateFormatter.string(from: self.datePickerView.date)
        tblFilterCriteria.reloadData()
        view.endEditing(true)
    }
    @objc func doneStartTimePicker(sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone =  TimeZone.current
        
        //======formate the start and end time with 30 min difference=======
        let pickedDate = self.startMeetingTimePickerView.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: pickedDate)
        let minute = components.minute!
        print("minute : \(minute)")
        if(minute >= 0 && minute < 30 )
        {
            let diff:Float = Float(minute)
            let _date = (self.startMeetingTimePickerView.date).addingTimeInterval(TimeInterval(-diff * 60.0))
            self.selectedStartMeetingTime = dateFormatter.string(from: _date)
           
            let endDate = (_date).addingTimeInterval(TimeInterval(30.0 * 60.0))
            self.selectedEndMeetingTime = dateFormatter.string(from: endDate)

            dateFormatter.dateFormat = "HH:mm"
            self.startMeetingTimeForService = dateFormatter.string(from: _date)
            self.endMeetingTimeForService  = dateFormatter.string(from: endDate)
            
            
            dateFormatter.dateFormat = "HH:mm:ss"
            
            tblFilterCriteria.reloadData()
        }
        else if (minute >= 30 && minute <= 60 )
        {
            let diff:Float = Float(minute - 30)
            let _date = (self.startMeetingTimePickerView.date).addingTimeInterval(TimeInterval(-diff * 60.0))
            self.selectedStartMeetingTime = dateFormatter.string(from: _date)

            let endDate = (_date).addingTimeInterval(TimeInterval(30.0 * 60.0))
            self.selectedEndMeetingTime = dateFormatter.string(from: endDate)

            dateFormatter.dateFormat = "HH:mm"
            self.startMeetingTimeForService = dateFormatter.string(from: _date)
            self.endMeetingTimeForService  = dateFormatter.string(from: endDate)
            tblFilterCriteria.reloadData()
        }
        //===============================================================================
        
        tblFilterCriteria.reloadData()
        view.endEditing(true)
    }
    
    @objc func doneEndTimePicker(sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.selectedEndMeetingTime = dateFormatter.string(from: self.endMeetingTimePickerView.date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        self.endMeetingTimeForService  = dateFormatter.string(from:  self.endMeetingTimePickerView.date)
        
        tblFilterCriteria.reloadData()
        view.endEditing(true)
    }
    
    @objc func cancelPicker(sender: Any) {
        
        selectedIndexLocationPicker = 0
        selectedIndexCapacityPicker = 0
        view.endEditing(true)
    }
    
}


extension SEFilterViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 100 ? self.capacityArray.count : self.locationArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var pickerValue = ""
        
        if (pickerView.tag == 100)
        {
            pickerValue = self.capacityArray[row]
        }
        else{
            pickerValue = self.locationArray[row]
        }
        return pickerValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 100)
        {
            selectedIndexCapacityPicker = row
        }
        else{
            selectedIndexLocationPicker = row
        }
    }
    
}
