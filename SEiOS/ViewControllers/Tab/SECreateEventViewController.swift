//
//  SECreateEventViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
import Alamofire


struct EmailAddress {
    var address = ""
    var name = ""
}
extension UIToolbar {
    
    func ToolbarPiker(doneSelect : Selector, cancelSelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: cancelSelect)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: doneSelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

class SECreateEventViewController: SEBaseViewController, SERoomDetailsDelegate, UpdateAttendeeListDelegate {
    func showMeetingRoomDetails(meetingRoomDetails: MeetingRoomDetails, meetingStartTime: String, meetingEndTime: String, MeetingDate: String) {
        
        //================================================================//
        let dateFormatter = DateFormatter()
       
        if(MeetingDate != "")
        {
            self.dateFromDatePicker = MeetingDate
            self.dateForService = MeetingDate
        }
        if(meetingStartTime != "")
        {
            self.startMeetingTime = meetingStartTime
            
            dateFormatter.dateFormat = "hh:mm a"
            let _time = dateFormatter.date(from: meetingStartTime)
            dateFormatter.dateFormat = "HH:mm:ss"
            self.startMeetingTimeForService = dateFormatter.string(from: _time!)
        }
        if(meetingEndTime != "")
        {
            self.endMeetingTime = meetingEndTime
            print("endMeetingTime :\(endMeetingTime)")
            dateFormatter.dateFormat = "hh:mm a"
            let _time = dateFormatter.date(from: meetingEndTime)
            dateFormatter.dateFormat = "HH:mm:ss"
            self.endMeetingTimeForService = dateFormatter.string(from: _time!)
        }
        
        //================================================================//
       
        self.meetingRoomDetails = meetingRoomDetails
        DispatchQueue.main.async {
            self.tblCreateEvent.reloadData()
        }
    }

    
    
    //let roomTitles_Array  = ["Jupiter", "Venus", "America", "Singapoor"]
    
    let eventHeadingArray1 = [
        ["name": "Location", "image": "icon_location"],
         ["name": "Select Date And Time", "image": "icon_date"]]
    let eventHeadingArray2 =  [
        ["name": "Select People", "image": "icon_people"]]
    var eventHeadingArray3 = [ ["name": "Description", "image": "icon_description"],
                               ["name": "All-day Event", "image": "icon_time"],
                               ["name": "Event Title", "image": "icon_event_title"],
                               ["name": "Repeat", "image": "icon_repeat"],
                               ["name": "Alert", "image": "icon_alert"]
                              ]
    
    
    @IBOutlet weak var tblCreateEvent: UITableView!
    @IBOutlet weak var tblBGFadeView: UIView!
    var meetingRoomDetails = MeetingRoomDetails()
    var attendeeName = [SEAttendeeUserModel]()
    var webServiceAPI = SEWebServiceAPI()
    var attendeeList = [EmailAddress]()
    var eventTitle = ""
    var eventDescription = "Seven-Eleven Book Meeting room testing - POC."

    var startMeetingTimeForService = ""
    var endMeetingTimeForService = ""
    var dateForService = ""
    var occurString : String = "Never"
    
    
    //var timePickerView:UIDatePicker = UIDatePicker()
    var datePickerView:UIDatePicker = UIDatePicker()
    var startMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var endMeetingTimePickerView:UIDatePicker = UIDatePicker()
    
    var recurrenceDueDate:UIDatePicker = UIDatePicker()
    
    var dateFromDatePicker = ""
    var startMeetingTime = ""
    var endMeetingTime = ""
    var recurrenceDueDateString = ""
    var serviceRecurrenceDueDateString = ""
    
    
    //Varibles from Custome Date Picker
    var selectedDateIndex = 0
    var selectedTimeIndex = 0
    var selectedEndTimeIndex = 0
    var pickerView = UIPickerView()
    var days = [Date]()
    var startTimes = [Date]()
    var endTimes = [Date]()
    
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let calender = Calendar.current
        let y = calender.date(byAdding: .month, value: 3, to: date)
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        recurrenceDueDateString =  df.string(from: y!)
        df.dateFormat = "yyyy-MM-dd"
        serviceRecurrenceDueDateString = df.string(from: y!)
        self.configureInitiallyView()
        self.hideKeyboardWhenTappedAround()
        
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
        self.navigationController?.navigationBar.isHidden = true
        let nib = UINib(nibName: "SECreateEventTableViewCell", bundle: nil)
        let nib1 = UINib(nibName: "SEAttendeesListCell", bundle: nil)
        self.tblCreateEvent.register(nib, forCellReuseIdentifier: "CreateEventCell")
        self.tblCreateEvent.register(nib1, forCellReuseIdentifier: "attendeesListCell")
        
        
        //---Setting for Custome Date Picker
        dayFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.timeStyle = .short
        days = setDays()
        startTimes = setStartTimes()
        endTimes = setEndTimes()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        recurrenceDueDate.datePickerMode = .date
    }
    
    func updateAttendeesList(list: Array<Any>) {
        attendeeName = list as! [SEAttendeeUserModel]
        for item in attendeeName{
            var obj = EmailAddress()
            obj.address = item.mail
            obj.name = item.displayName
            attendeeList.append(obj)
        }
        DispatchQueue.main.async {
            self.tblCreateEvent.reloadData()
        }
    }
    
    func showAlert(Message : String){
        let alertController = UIAlertController(title: "", message: Message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SECreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            switch indexPath.row{
            case 0:
                return 90
            default:
                return 40
            }
        default:
            return 90
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return eventHeadingArray1.count
        case 1:
            return eventHeadingArray2.count + attendeeName.count
        default:
            return eventHeadingArray3.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
                
            case 0:
                //====Location===//
                let cellIdentifier = "CreateEventCell"
                var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SECreateEventTableViewCell//tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventTableViewCell?
                if (cell == nil) {
                    cell = Bundle.main.loadNibNamed("SECreateEventTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventTableViewCell
                    cell?.accessoryType = UITableViewCellAccessoryType.none
                }
                
                UITableViewCell.appearance().backgroundColor = .clear
                cell?.contentView.backgroundColor = UIColor.clear
                cell?.layer.backgroundColor = UIColor.clear.cgColor
                cell?.selectionStyle = .none
                
                let item = eventHeadingArray1[indexPath.row]
                let titleStr = item["name"]
                let titleImage = item["image"]
                cell?.imageView?.image = UIImage(named: titleImage!)
                cell?.lblTitle.text = titleStr
                cell?.txtField.text = ""
                cell?.btnAdd.isHidden = false
                cell?.btnAddAttendees.isHidden = true
                cell?.lblLine.isHidden = false
                
                cell?.txtField.isHidden = false
                cell?.txtField.isUserInteractionEnabled = false
                
                cell?.lblMeetingInterval.isHidden = true
                cell?.txtStartMeetingTime.isHidden = true
                cell?.txtEndMeetingTime.isHidden = true
                
                var placeHolderText  = ""
                if self.meetingRoomDetails.meetingRoomName != ""
                {
                    cell?.txtField.text = self.meetingRoomDetails.meetingRoomName
                }
                else
                {
                    placeHolderText = "Select meeting room"
                }
                
                var placeHolder = NSMutableAttributedString()
                // Set the Font
                placeHolder = NSMutableAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 12)])
                // Set the color
                placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range:NSRange(location:0, length:placeHolderText.count))
                // Add attribute
                cell?.txtField.attributedPlaceholder = placeHolder
                cell?.btnAdd.addTarget(self, action: #selector(tblCellBtn_AddRoom_Tapped), for: .touchUpInside)
                return cell!
            
            default:
                 print("Row 1")
                
                 let cellIdentifier = "datePickerCell"
                 var cell : SECreateEventDatePickerTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventDatePickerTableViewCell?
                 
                 if (cell == nil) {
                    cell = Bundle.main.loadNibNamed("SECreateEventDatePickerTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventDatePickerTableViewCell
                    cell?.accessoryType = UITableViewCellAccessoryType.none
                 }
                 UITableViewCell.appearance().backgroundColor = .clear
                 cell?.contentView.backgroundColor = UIColor.clear
                 cell?.layer.backgroundColor = UIColor.clear.cgColor
                 cell?.selectionStyle = .none
                 
                 let item = eventHeadingArray1[indexPath.row]
                 let titleStr = item["name"]
                 let titleImage = item["image"]
                 cell?.imageView?.image = UIImage(named: titleImage!)
                 cell?.lblTitle.text = titleStr
                
                 var placeholderString = ""
                 if (self.dateFromDatePicker != "")
                 {
                    cell?.txtDate.text = self.dateFromDatePicker
                 }
                 else{
                    var placeholderString = "Meeting Date"
                    cell?.txtDate.attributedPlaceholder = placeholderString.getPlaceholderString()
                 }
                
                 if (self.startMeetingTime != "")
                 {
                    cell?.txtStartTime.text = self.startMeetingTime
                 }
                 else{
                    placeholderString = "Start Time"
                    cell?.txtStartTime.attributedPlaceholder = placeholderString.getPlaceholderString()
                 }
                
                 if (self.endMeetingTime != "")
                 {
                    cell?.txtEndTime.text = self.endMeetingTime

                 }
                 else{
                    placeholderString = "End Time"
                    cell?.txtEndTime.attributedPlaceholder = placeholderString.getPlaceholderString()
                 }
                 
                 cell?.customeDatePickerView.backgroundColor = UIColor.clear
                 
                 var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(donePickerAction), cancelSelect: #selector(cancelPickerAction))
                 cell?.txtDate.inputView = self.pickerView
                 cell?.txtDate.inputAccessoryView = toolbar
                 
                 cell?.txtStartTime.inputView = self.pickerView
                 cell?.txtStartTime.inputAccessoryView = toolbar
                 
                 cell?.txtEndTime.inputView = self.pickerView
                 cell?.txtEndTime.inputAccessoryView = toolbar
                 
               
                 return cell!
            }
            
           
        case 1:
            switch indexPath.row{
            case 0 :
                let cellIdentifier = "CreateEventCell"
                var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SECreateEventTableViewCell//tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventTableViewCell?
                if (cell == nil) {
                    cell = Bundle.main.loadNibNamed("SECreateEventTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventTableViewCell
                    cell?.accessoryType = UITableViewCellAccessoryType.none
                }
                UITableViewCell.appearance().backgroundColor = .clear
                cell?.contentView.backgroundColor = UIColor.clear
                cell?.layer.backgroundColor = UIColor.clear.cgColor
                cell?.selectionStyle = .none
                let item = eventHeadingArray2[indexPath.row]
                let titleStr = item["name"]
                let titleImage = item["image"]
                cell?.imageView?.image = UIImage(named: titleImage!)
                cell?.lblTitle.text = titleStr
                cell?.btnAdd.isHidden = true
                cell?.btnAddAttendees.isHidden = false
                cell?.txtField.isHidden = false
                cell?.txtField.isUserInteractionEnabled = false
                cell?.lblLine.isHidden = false
                cell?.lblMeetingInterval.isHidden = true
                cell?.txtStartMeetingTime.isHidden = true
                cell?.txtEndMeetingTime.isHidden = true
                
                
                var placeHolderText  = ""
                placeHolderText = "Tap to add people from contacts"
                var placeHolder = NSMutableAttributedString()
                // Set the Font
                placeHolder = NSMutableAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 12)])
                // Set the color
                placeHolder.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range:NSRange(location:0, length:placeHolderText.count))
                // Add attribute
                cell?.txtField.attributedPlaceholder = placeHolder
                cell?.btnAddAttendees.addTarget(self, action: #selector(tblCellBtn_AddAttendee_Tapped), for: .touchUpInside)
                return cell!
            default:
                let cellIdentifier = "attendeesListCell"
                var cell : SEAttendeesListCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SEAttendeesListCell
                if (cell == nil) {
                    cell = Bundle.main.loadNibNamed("SEAttendeesListCell", owner: nil, options: nil)?[0] as? SEAttendeesListCell
                    cell?.accessoryType = UITableViewCellAccessoryType.none
                }
                UITableViewCell.appearance().backgroundColor = .clear
                cell?.contentView.backgroundColor = UIColor.clear
                cell?.layer.backgroundColor = UIColor.clear.cgColor
                cell?.selectionStyle = .none
                
                
                let model = attendeeName[indexPath.row-1]
                cell?.lblUsername.text = model.displayName
                cell?.imgProfilePic.image = UIImage.init(named: "icon_my_contacts")
                cell?.btnRemove.isHidden = false
                cell?.btnRemove.addTarget(self, action: #selector(tblCellBtn_RemoveAttendee_Tapped), for: .touchUpInside)
                return cell!
            }
            
        default:
            let cellIdentifier = "CreateEventCell"
            var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SECreateEventTableViewCell
            if (cell == nil) {
                cell = Bundle.main.loadNibNamed("SECreateEventTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventTableViewCell
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            UITableViewCell.appearance().backgroundColor = .clear
            cell?.contentView.backgroundColor = UIColor.clear
            cell?.layer.backgroundColor = UIColor.clear.cgColor
            cell?.selectionStyle = .none
            
            
            cell?.txtStartMeetingTime.isHidden = true
            cell?.txtEndMeetingTime.isHidden = true
            
            
            let item = eventHeadingArray3[indexPath.row]
            let titleStr = item["name"]
            let titleImage = item["image"]
            cell?.imageView?.image = UIImage(named: titleImage!)
            cell?.lblTitle.text = titleStr
            cell?.btnAdd.isHidden = true
            cell?.btnAddAttendees.isHidden = true
            
            OperationQueue.main.addOperation {
                    cell?.txtEndMeetingTime.isHidden = true
                    cell?.txtStartMeetingTime.isHidden = true
                    cell?.lblMeetingInterval.isHidden = true
                    cell?.lblLine.isHidden = false
            }
            
            OperationQueue.main.addOperation {
                if indexPath.row == 1{
                    cell?.switchToggleday.isHidden = false
                }else{
                    cell?.switchToggleday.isHidden = true
                }
            }
            
            cell?.txtField.isHidden = false
            cell?.txtField.text = ""
            cell?.txtField.isUserInteractionEnabled = false
            var placeHolderText  = ""
            switch indexPath.row {
                
            case 0:
                placeHolderText = "Write your description here"
                cell?.txtField.isUserInteractionEnabled = true
                cell?.txtField.text = ""
                cell?.txtField.tag = 100
                cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
                
                break
                
            case 1:
                cell?.lblLine.isHidden = true
                cell?.txtField.isHidden = true
                break
            case 2:
                cell?.txtField.tag = indexPath.row
                cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
                cell?.txtField.isUserInteractionEnabled = true
                if self.eventTitle != "" {
                    cell?.txtField.text = self.eventTitle
                }else{
                    placeHolderText = "Enter title"
                }
                break
            case 3:
                cell?.txtField.text = self.occurString
                break
            case 4:
                let y = eventHeadingArray3[4]
                if y["name"] == "Until"{
                    cell?.txtField.text = recurrenceDueDateString
                    cell?.txtField.isUserInteractionEnabled = true
                    cell?.txtField.inputView = recurrenceDueDate
                    var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(donePickerAction), cancelSelect: #selector(cancelPickerAction))
                    cell?.txtField.inputAccessoryView = toolbar
                }else{
                    placeHolderText = "15 minutes before"
                    cell?.txtField.text = ""
                }
                
                break
            case 5:
                placeHolderText = "15 minutes before"
                cell?.txtField.text = ""
                break
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
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 50
        }else{
            return 0
        }
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
    
    //--------------------
    
    //=====ToolBar Method
   
     @objc func donePickerAction() {
        let y = eventHeadingArray3[4]
        if y["name"] == "Until" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            recurrenceDueDateString = formatter.string(from: recurrenceDueDate.date)
            formatter.dateFormat = "yyyy-MM-dd"
            serviceRecurrenceDueDateString = formatter.string(from: recurrenceDueDate.date)
            self.view.endEditing(true)
            self.tblCreateEvent.reloadData()
            
            
        }else{
            let dateString = getDayString(from: days[self.selectedDateIndex])
            let timeString = getTimeString(from: startTimes[self.selectedTimeIndex])
            let endTimeString = getTimeString(from: endTimes[self.selectedEndTimeIndex])
            print("----\(dateString) : \(timeString)  : \(endTimeString)---")
            
            let dateFormatter = DateFormatter()
            
            self.dateFromDatePicker = dateString
            self.dateForService = dateString
            
            self.startMeetingTime = timeString
            self.endMeetingTime = endTimeString
            
            dateFormatter.dateFormat = "hh:mm a"
            let _time = dateFormatter.date(from: timeString)
            let _endtime = dateFormatter.date(from: endTimeString)
            
            dateFormatter.dateFormat = "HH:mm:ss"
            self.startMeetingTimeForService = dateFormatter.string(from: _time!)
            self.endMeetingTimeForService = dateFormatter.string(from: _endtime!)
            
            self.tblCreateEvent.reloadData()
            view.endEditing(true)
        }
        
        
    }
    
    @objc func cancelPickerAction() {
       // self.tblCreateEvent.reloadData()
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    @objc func createEventAction() {
        print("Add event!!")
        
        self.startLoading()
        let url = SEWebserviceClient.eventURL
        
        print("eventDescription :\(eventDescription)")
        
        let bodyDict: [String: String] = ["contentType": "HTML",
                                          "content": "\(eventDescription)"]
        
        
        let startDict: [String: String] = ["dateTime": "\(dateForService)T\(startMeetingTimeForService)",
            "timeZone": "India Standard Time"]
        
        let endDict: [String: String] = ["dateTime": "\(dateForService)T\(endMeetingTimeForService)",
            "timeZone": "India Standard Time"]
        
        
        var attendeesArray = [[String: Any]]()
        
        
        for item in self.attendeeList {
            let emailDetailsDict: [String: String] = ["address": item.address,
                                                      "name": item.name]
            
            let emailAddressDict: [String: Any] = ["emailAddress": emailDetailsDict,
                                                   "type": "Required"]
            
            attendeesArray.append(emailAddressDict)
        }
        
        
        
        let locationDict: [String: String] = ["displayName": self.meetingRoomDetails.meetingRoomName,
                                              "locationType": "conferenceRoom"]
        
        
        var locationsArray = [[String: Any]]()
        let locationsDict: [String: String] = ["displayName": self.meetingRoomDetails.meetingRoomName]
        locationsArray.append(locationsDict)
        
//        "recurrence":{
//            "pattern":{
//                "type":"daily",
//                "interval":1,
//                "month":0,
//                "dayOfMonth":0,
//                "daysOfWeek":[
//                "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"
//                ],
//                "firstDayOfWeek":"monday",
//                "index":"first"
//            },
//            "range":{
//                "type":"endDate",
//                "startDate":"2017-09-04",
//                "endDate":"2017-12-31",
//                "recurrenceTimeZone":"UTC",
//                "numberOfOccurrences":0
//            }
//        },
        
        let patternDict : [String: Any] = [
            "type":"daily",
            "interval":1,
            "month":0,
            "dayOfMonth":0,
            "daysOfWeek":["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"],
            "firstDayOfWeek":"monday",
            "index":"first"
            ]
         let rangeDict : [String: Any] = [
            "type":"endDate",
            "startDate":dateForService,
            "endDate":serviceRecurrenceDueDateString,
            "recurrenceTimeZone":"UTC",
            "numberOfOccurrences":0
        ]
        let recurrenceDict : [String: Any] = [
            "pattern":patternDict,
            "range":rangeDict
        ]
        let parameters : Parameters!
        if occurString == "Never"{
            parameters = ["subject": self.eventTitle,
                          "body": bodyDict,
                          "start": startDict,
                          "end": endDict,
                          "attendees": attendeesArray,
                          "location": locationDict,
                          "locations": locationsArray]
        }else{
            parameters = ["subject": self.eventTitle,
            "body": bodyDict,
            "start": startDict,
            "end": endDict,
            "recurrence": recurrenceDict,
            "attendees": attendeesArray,
            "location": locationDict,
            "locations": locationsArray]
        }
        
        print("parameters : \(parameters)")
        
        
        webServiceAPI.createEventAPI(url: url, parameters: parameters, onSuccess: { (response) in
            if response is String{
                if response as! String == "Event created successfully!"{
                    self.stopLoading()
                    self.clearForm()
                }else{
                    self.stopLoading()
                    self.showAlert(Message: "Error while creating event. Please try after sometime!")
                }
            }else{
                self.stopLoading()
                self.showAlert(Message: "Error while creating event. Please try after sometime!")
            }
        
        }, onError:{ error in
            self.showAlert(Message: "Something went wrong!")
            self.stopLoading()
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            self.performSegue(withIdentifier: "addAttendee", sender: nil)
            break
        case 2 :
            
            switch indexPath.row{
            case 3:
                let actionSheetController = UIAlertController(title: "Select occurrence", message: nil, preferredStyle: .actionSheet)
                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheetController.addAction(cancelActionButton)
                
                let neverActionButton = UIAlertAction(title: "Never", style: .default) { action -> Void in
                    self.occurString = "Never"
                    if self.eventHeadingArray3.count == 6 {
                        self.eventHeadingArray3.remove(at: 4)
                    }
                    DispatchQueue.main.async {
                        self.tblCreateEvent.reloadData()
                    }
                    
                }
                actionSheetController.addAction(neverActionButton)
                let everyDayActionButton = UIAlertAction(title: "Every day", style: .default) { action -> Void in
                    self.occurString = "Every day"
                    if self.eventHeadingArray3.count == 5 {
                        self.eventHeadingArray3.insert(["name": "Until", "image": "icon_repeat"], at: 4)
                    }
                    DispatchQueue.main.async {
                        self.tblCreateEvent.reloadData()
                    }
                }
                actionSheetController.addAction(everyDayActionButton)
                
                self.present(actionSheetController, animated: true, completion: nil)
                break
            case 4:
                let y = eventHeadingArray3[4]
                if y["name"] == "Until"{
                    print("AAYA")
                }
                break
            default:
                break
                
            }
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
    
    
    @objc func textFieldValueChangedAction(textField: UITextField) {
        
        if textField.tag == 2 {
            self.eventTitle = textField.text!
        }
        
        if textField.tag == 100
        {
            self.eventDescription = textField.text!
        }
    }
    
    func clearForm() {
        attendeeList.removeAll()
        eventTitle = ""
        startMeetingTimeForService = ""
        endMeetingTimeForService = ""
        dateForService = ""
        attendeeName.removeAll()
        dateFromDatePicker = ""
        startMeetingTime = ""
        endMeetingTime = ""
        DispatchQueue.main.async {
            self.tblCreateEvent.reloadData()
        }
    }
    
    @objc func tblCellBtn_AddRoom_Tapped(){
        self.performSegue(withIdentifier: "event2RoomSearch", sender: nil)
    }
    
    @objc func tblCellBtn_AddAttendee_Tapped(){
        self.performSegue(withIdentifier: "addAttendee", sender: nil)
    }
    
    @objc func tblCellBtn_RemoveAttendee_Tapped(){
        print("df")
    }
}

extension SECreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return startTimes.count
        case 2:
            return endTimes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        var text = ""
        
        switch component {
        case 0:
            text = getDayString(from: days[row])
        case 1:
            text = getTimeString(from: startTimes[row])
        case 2:
            text = getTimeString(from: endTimes[row])
        default:
            break
        }
        label.text = text
        
        return label
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var dateString = ""
        var timeString = ""
        var endTimeString = ""
        
        switch component {
        case 0:
            dateString = getDayString(from: days[row])
            self.selectedDateIndex = row
        case 1:
            timeString = getTimeString(from: startTimes[row])
            self.selectedTimeIndex = row
        case 2:
            endTimeString = getTimeString(from: endTimes[row])
            self.selectedEndTimeIndex = row
        default:
            break
        }
        //  print("\(dateString) : \(timeString)  : \(endTimeString)")
    }
}


extension SECreateEventViewController {
    func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        
        // first date
        var currentDate = date
        
        // adding 30 days to current date
        let oneMonthFromNow = calendar.date(byAdding: .day, value: 30, to: currentDate)
        
        // last date
        let endDate = oneMonthFromNow
        
        while currentDate <= endDate! {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func getTimes(of date: Date) -> [Date] {
        var times = [Date]()
        var currentDate = date
        
        currentDate = Calendar.current.date(bySetting: .hour, value: 7, of: currentDate)!
        currentDate = Calendar.current.date(bySetting: .minute, value: 00, of: currentDate)!
        
        let calendar = Calendar.current
        
        let interval = 30//60
        var nextDiff = interval - calendar.component(.minute, from: currentDate) % interval
        var nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: currentDate) ?? Date()
        
        var hour = Calendar.current.component(.hour, from: nextDate)
        
        while(hour < 23) {
            times.append(nextDate)
            
            nextDiff = interval - calendar.component(.minute, from: nextDate) % interval
            nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: nextDate) ?? Date()
            
            hour = Calendar.current.component(.hour, from: nextDate)
        }
        
        return times
    }
    
    func setDays() -> [Date] {
        let today = Date()
        return getDays(of: today)
    }
    
    func setStartTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
    }
    
    func setEndTimes() -> [Date] {
        let today = Date()
        return getTimes(of: today)
    }
    
    func getDayString(from: Date) -> String {
        return dayFormatter.string(from: from)
    }
    
    func getTimeString(from: Date) -> String {
        return timeFormatter.string(from: from)
    }
}

extension SECreateEventViewController : UIActionSheetDelegate {
   
    
    
    
}


