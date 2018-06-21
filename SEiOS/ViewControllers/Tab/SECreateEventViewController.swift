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
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        
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
        ["name": "Location", "image": "icon_location"]]
    let eventHeadingArray2 =  [
        ["name": "Select People", "image": "icon_people"]]
    let eventHeadingArray3 = [ ["name": "Select Date", "image": "icon_date"],
                               ["name": "All-day Event", "image": ""],
                               ["name": "Event Created By", "image": "icon_my_contacts"],
                               ["name": "Event Title", "image": "icon_event_title"],
                               ["name": "Select Time", "image": "icon_time"],
                               ["name": "Repeat", "image": "icon_repeat"],
                               ["name": "Alert", "image": "icon_alert"],
                               ["name": "Description", "image": "icon_description"]]
    
    
    @IBOutlet weak var tblCreateEvent: UITableView!
    @IBOutlet weak var tblBGFadeView: UIView!
    var meetingRoomDetails = MeetingRoomDetails()
    var attendeeName = [SEAttendeeUserModel]()
    var webServiceAPI = SEWebServiceAPI()
    var attendeeList = [EmailAddress]()
    var eventTitle = ""
    var startMeetingTimeForService = ""
    var endMeetingTimeForService = ""
    var dateForService = ""
    var occurString : String = "Never"
    
    
    //var timePickerView:UIDatePicker = UIDatePicker()
    var datePickerView:UIDatePicker = UIDatePicker()
    var startMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var endMeetingTimePickerView:UIDatePicker = UIDatePicker()
    
    var dateFromDatePicker = ""
    var startMeetingTime = ""
    var endMeetingTime = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            let cellIdentifier = "CreateEventCell"
            var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SECreateEventTableViewCell//tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventTableViewCell?
            if (cell == nil) {
                cell = Bundle.main.loadNibNamed("SECreateEventTableViewCell", owner: nil, options: nil)?[0] as? SECreateEventTableViewCell
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            
            
            //            for subview in (cell?.contentView.subviews)! {
            //                subview.removeFromSuperview()
            //            }
            
            UITableViewCell.appearance().backgroundColor = .clear
            cell?.contentView.backgroundColor = UIColor.clear
            cell?.layer.backgroundColor = UIColor.clear.cgColor
            cell?.selectionStyle = .none
            
            let item = eventHeadingArray1[indexPath.row]
            let titleStr = item["name"]
            let titleImage = item["image"]
            cell?.imageView?.image = UIImage(named: titleImage!)
            cell?.lblTitle.text = titleStr
            
            
            
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
                if(indexPath.row == 4)
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
            
            OperationQueue.main.addOperation {
                if indexPath.row == 1{
                    cell?.switchToggleday.isHidden = false
                }else{
                    cell?.switchToggleday.isHidden = true
                }
            }
            
            
            cell?.txtField.isHidden = false
            cell?.txtField.isUserInteractionEnabled = false
            var placeHolderText  = ""
            switch indexPath.row {
                
            case 0:
                //placeHolderText = "Tuesday, 5 Jun"
                cell?.txtField.isUserInteractionEnabled = true
                
                datePickerView.minimumDate = Date()
                datePickerView.datePickerMode = UIDatePickerMode.date
                cell?.txtField.inputView = datePickerView
                let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SECreateEventViewController.doneDatePicker), cancelSelect: #selector(SECreateEventViewController.cancelPicker))
                
                cell?.txtField.inputAccessoryView = toolBar
                
                if(self.dateFromDatePicker != "")
                {
                    cell?.txtField.text = self.dateFromDatePicker
                }
                else{
                    placeHolderText = "Please select date"
                }
                break
            case 1:
                cell?.lblLine.isHidden = true
                cell?.txtField.isHidden = true
                break
            case 2:
                cell?.txtField.text = username
                cell?.txtField.tag = indexPath.row
                cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
                cell?.txtField.isUserInteractionEnabled = false
                
                //            if self.eventTitle != "" {
                //                cell?.txtField.text = self.eventTitle
                //            }
                break
            case 3:
                cell?.txtField.tag = indexPath.row
                cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
                cell?.txtField.isUserInteractionEnabled = true
                if self.eventTitle != "" {
                    cell?.txtField.text = self.eventTitle
                }else{
                    placeHolderText = "Enter title"
                }
                break
            case 4:
                //placeHolderText = "10:00 AM"
                let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SECreateEventViewController.doneStartTimePicker), cancelSelect: #selector(SECreateEventViewController.cancelPicker))
                
                startMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
                cell?.txtStartMeetingTime.inputView = startMeetingTimePickerView
                cell?.txtStartMeetingTime.inputAccessoryView = toolBar
                cell?.txtField.isHidden = true
                if(self.startMeetingTime != "")
                {
                    cell?.txtStartMeetingTime.text = self.startMeetingTime
                }
                else{
                    let placeholderString = "Start Time"
                    cell?.txtStartMeetingTime.attributedPlaceholder = placeholderString.getPlaceholderString()
                }
                
                
                let endToolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SECreateEventViewController.doneEndTimePicker), cancelSelect: #selector(SECreateEventViewController.cancelPicker))
                
                endMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
                cell?.txtEndMeetingTime.inputView = endMeetingTimePickerView
                cell?.txtEndMeetingTime.inputAccessoryView = endToolBar
                
                if(self.endMeetingTime != "")
                {
                    cell?.txtEndMeetingTime.text = self.endMeetingTime
                }
                else{
                    let placeholderString = "End Time"
                    cell?.txtEndMeetingTime.attributedPlaceholder = placeholderString.getPlaceholderString()
                }
                break
            case 5:
                //placeHolderText = "Never"
                cell?.txtField.text = self.occurString
                break
            case 6:
                placeHolderText = "15 minutes before"
                cell?.txtField.text = ""
                break
            case 7:
                placeHolderText = "Write your description here"
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
    @objc func doneDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.dateFromDatePicker = dateFormatter.string(from: self.datePickerView.date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateForService = dateFormatter.string(from: self.datePickerView.date)
        
        self.tblCreateEvent.reloadData()
        view.endEditing(true)
    }
    @objc func doneStartTimePicker() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.startMeetingTime = dateFormatter.string(from: self.startMeetingTimePickerView.date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        self.startMeetingTimeForService = dateFormatter.string(from: self.startMeetingTimePickerView.date)
        print(self.startMeetingTimeForService)
        
        self.tblCreateEvent.reloadData()
        view.endEditing(true)
    }
    
    @objc func doneEndTimePicker() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.endMeetingTime = dateFormatter.string(from: self.endMeetingTimePickerView.date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        self.endMeetingTimeForService  = dateFormatter.string(from:  self.endMeetingTimePickerView.date)
        
        
        self.tblCreateEvent.reloadData()
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    
    @objc func createEventAction() {
        print("Add event!!")
        
        self.startLoading()
        let url = SEWebserviceClient.eventURL
        
        let bodyDict: [String: String] = ["contentType": "HTML",
                                          "content": "Seven-Eleven Book Meeting room testing - POC."]
        
        
        
        //        let startDict: [String: String] = ["dateTime": "2018-06-16T22:00:00",
        //                                           "timeZone": "India Standard Time"]
        //
        //        let endDict: [String: String] = ["dateTime": "2018-06-16T23:00:00",
        //                                         "timeZone": "India Standard Time"]
        
        
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
        
        let parameters : Parameters = ["subject": self.eventTitle,
                                       "body": bodyDict,
                                       "start": startDict,
                                       "end": endDict,
                                       "attendees": attendeesArray,
                                       "location": locationDict,
                                       "locations": locationsArray]
        
        
        webServiceAPI.createEventAPI(url: url, parameters: parameters, onSuccess: { (response) in
            print("createEventAPI.createEventAPI")
            self.stopLoading()
            self.clearForm()
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
        switch indexPath.section {
        case 1:
            self.performSegue(withIdentifier: "addAttendee", sender: nil)
            break
        case 2 :
            
            switch indexPath.row{
            case 5:
                let actionSheetController = UIAlertController(title: "Select occurrence", message: nil, preferredStyle: .actionSheet)
                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheetController.addAction(cancelActionButton)
                
                let neverActionButton = UIAlertAction(title: "Never", style: .default) { action -> Void in
                    self.occurString = "Never"
                    DispatchQueue.main.async {
                        self.tblCreateEvent.reloadData()
                    }
                    
                }
                actionSheetController.addAction(neverActionButton)
                let everyDayActionButton = UIAlertAction(title: "Every day", style: .default) { action -> Void in
                    self.occurString = "Every day"
                    DispatchQueue.main.async {
                        self.tblCreateEvent.reloadData()
                    }
                }
                actionSheetController.addAction(everyDayActionButton)
                
                let everyWeekActionButton = UIAlertAction(title: "Every week", style: .default) { action -> Void in
                    self.occurString = "Every week"
                    DispatchQueue.main.async {
                        self.tblCreateEvent.reloadData()
                    }
                }
                actionSheetController.addAction(everyWeekActionButton)
                self.present(actionSheetController, animated: true, completion: nil)
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
        
        if textField.tag == 3 {
            self.eventTitle = textField.text!
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


extension SECreateEventViewController : UIActionSheetDelegate {
    
    
    
}


