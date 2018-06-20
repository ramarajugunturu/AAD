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
    
    func showMeetingRoomDetails(meetingRoomDetails: MeetingRoomDetails) {
        self.meetingRoomDetails = meetingRoomDetails
        self.tblCreateEvent.reloadData()
    }
    
    
    //let roomTitles_Array  = ["Jupiter", "Venus", "America", "Singapoor"]
    
    let eventHeadingArray = [
                             ["name": "Location", "image": "icon_location"],
                             ["name": "Select People", "image": "icon_people"],
                             ["name": "Select Date", "image": "icon_date"],
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
    var attendeeName : String! = ""
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
        self.tblCreateEvent.register(nib, forCellReuseIdentifier: "CreateEventCell")
    }
    
    func updateAttendeesList(list: Array<Any>) {
        attendeeName = ""
        if list.count != 0 {
            for item in list {
                let t = item as! SEAttendeeUserModel
                attendeeName.append("\(t.displayName!) ")
                var attendeeDetail = EmailAddress()
                attendeeDetail.address = t.mail
                attendeeDetail.name = t.displayName
                attendeeList.append(attendeeDetail)
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
        var cell : SECreateEventTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SECreateEventTableViewCell//tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SECreateEventTableViewCell?
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
        cell?.btnAdd.isHidden = true
        cell?.btnAddAttendees.isHidden = true
        OperationQueue.main.addOperation {
            if(indexPath.row == 6)
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
            if(indexPath.row == 0 || indexPath.row == 1)
            {
                
                switch indexPath.row {
                case 0 :
                    cell?.btnAdd.isHidden = false
                    cell?.btnAddAttendees.isHidden = true
                    cell?.btnAdd.addTarget(self, action: #selector(self.tblCellBtn_AddRoom_Tapped), for: .touchUpInside)
                    break
                case 1 :
                    cell?.btnAdd.isHidden = true
                    cell?.btnAddAttendees.isHidden = false
                    cell?.btnAddAttendees.addTarget(self, action: #selector(self.tblCellBtn_AddAttendee_Tapped), for: .touchUpInside)
                    break
                default:
                    break
                }
            }
            else
            {
                cell?.btnAdd.isHidden = true
            }
            if indexPath.row == 3{
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
            if self.meetingRoomDetails.meetingRoomName != ""
            {
                cell?.txtField.text = self.meetingRoomDetails.meetingRoomName
            }
            else
            {
                placeHolderText = "Select meeting room"
            }
            break
        case 1:
            if attendeeName == ""{
                cell?.txtField.text = ""
                placeHolderText = "Tap to add people from contacts"
            }
            else{
                cell?.txtField.isUserInteractionEnabled = false
                cell?.txtField.text = attendeeName
            }
            break
        case 2:
            //placeHolderText = "Tuesday, 5 Jun"
            cell?.txtField.isUserInteractionEnabled = true
            
            datePickerView.datePickerMode = UIDatePickerMode.date
            cell?.txtField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(SECreateEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
            let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SECreateEventViewController.donePicker), cancelSelect: #selector(SECreateEventViewController.cancelPicker))
            
            cell?.txtField.inputAccessoryView = toolBar
            
            if(self.dateFromDatePicker != "")
            {
                cell?.txtField.text = self.dateFromDatePicker
            }
            else{
                placeHolderText = "Please select date!"
            }
            break
        case 3:
            cell?.lblLine.isHidden = true
            cell?.txtField.isHidden = true
            break
        case 4:
            cell?.txtField.text = username
            cell?.txtField.tag = indexPath.row
            cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
            cell?.txtField.isUserInteractionEnabled = false
            
            //            if self.eventTitle != "" {
            //                cell?.txtField.text = self.eventTitle
            //            }
            break
        case 5:
            cell?.txtField.tag = indexPath.row
            cell?.txtField.addTarget(self, action: #selector(textFieldValueChangedAction(textField:)), for: .editingDidEnd)
            cell?.txtField.isUserInteractionEnabled = true
            if self.eventTitle != "" {
                cell?.txtField.text = self.eventTitle
            }else{
                placeHolderText = "Enter title"
            }
            break
        case 6:
            //placeHolderText = "10:00 AM"
            let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SECreateEventViewController.donePicker), cancelSelect: #selector(SECreateEventViewController.cancelPicker))
            
            startMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            startMeetingTimePickerView.addTarget(self, action: #selector(SECreateEventViewController.startTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            cell?.txtStartMeetingTime.inputView = startMeetingTimePickerView
            cell?.txtStartMeetingTime.inputAccessoryView = toolBar
            
            if(self.startMeetingTime != "")
            {
                cell?.txtStartMeetingTime.text = self.startMeetingTime
            }
            else{
                //placeHolderText = "HH:MM AM"
            }
            
            endMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            endMeetingTimePickerView.addTarget(self, action: #selector(SECreateEventViewController.endTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            cell?.txtEndMeetingTime.inputView = endMeetingTimePickerView
            cell?.txtEndMeetingTime.inputAccessoryView = toolBar
            
            if(self.endMeetingTime != "")
            {
                cell?.txtEndMeetingTime.text = self.endMeetingTime
            }
            else{
                //placeHolderText = "HH:MM AM"
            }
            break
        case 7:
            //placeHolderText = "Never"
            cell?.txtField.text = self.occurString
            break
        case 8:
            placeHolderText = "15 minutes before"
            cell?.txtField.text = ""
            break
        case 9:
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
    
    
    
    @objc func donePicker() {
        self.tblCreateEvent.reloadData()
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.dateFromDatePicker = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateForService = dateFormatter.string(from: sender.date)

        
        print(dateForService)
    }
    
    
    
    @objc func startTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.startMeetingTime = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        self.startMeetingTimeForService = dateFormatter.string(from: sender.date)

        print(self.startMeetingTimeForService)
        
    }
    
    @objc func endTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.endMeetingTime = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "HH:mm:ss"
        self.endMeetingTimeForService  = dateFormatter.string(from: sender.date)

        print(self.endMeetingTimeForService)
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
                                           "timeZone": "Central Standard Time"]
        
        let endDict: [String: String] = ["dateTime": "\(dateForService)T\(endMeetingTimeForService)",
                                         "timeZone": "Central Standard Time"]

        
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
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "event2RoomSearch", sender: nil)
            break
        case 1:
            self.performSegue(withIdentifier: "addAttendee", sender: nil)
            break
        case 7:
            let actionSheetController = UIAlertController(title: "Select occurrence", message: nil, preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let neverActionButton = UIAlertAction(title: "Never", style: .default) { action -> Void in
                self.occurString = "Never"
                self.tblCreateEvent.reloadData()
            
            }
            actionSheetController.addAction(neverActionButton)
            let everyDayActionButton = UIAlertAction(title: "Every day", style: .default) { action -> Void in
                self.occurString = "Every day"
                self.tblCreateEvent.reloadData()
            }
            actionSheetController.addAction(everyDayActionButton)
            
            let everyWeekActionButton = UIAlertAction(title: "Every week", style: .default) { action -> Void in
                self.occurString = "Every week"
                self.tblCreateEvent.reloadData()
            }
            actionSheetController.addAction(everyWeekActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
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
    
    
    @objc func textFieldValueChangedAction(textField: UITextField) {
        
        if textField.tag == 0 {
            self.eventTitle = textField.text!
        }
    }
    
    func clearForm() {
        attendeeList.removeAll()
        eventTitle = ""
        startMeetingTimeForService = ""
        endMeetingTimeForService = ""
        dateForService = ""
        attendeeName = ""
        dateFromDatePicker = ""
        startMeetingTime = ""
        endMeetingTime = ""
        tblCreateEvent.reloadData()
    }
    
    @objc func tblCellBtn_AddRoom_Tapped(){
        self.performSegue(withIdentifier: "event2RoomSearch", sender: nil)
    }
    
    @objc func tblCellBtn_AddAttendee_Tapped(){
        self.performSegue(withIdentifier: "addAttendee", sender: nil)
    }
    
    
    
}


extension SECreateEventViewController : UIActionSheetDelegate {
    
    
    
}


