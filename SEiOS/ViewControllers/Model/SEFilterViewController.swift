//
//  SEFilterViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit
extension UIButton{
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


class SEFilterViewController: SEBaseViewController {

    
    @IBOutlet weak var tblBGFadeView: UIView!
    @IBOutlet weak var tblFilterCriteria: UITableView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    let headingArray = [["name": "Available Date", "image": "icon_date"],
                        ["name": "Available Time", "image": "icon_time"],
                        ["name": "Capacity", "image": "icon_people"],
                        ["name": "Location", "image": "icon_location"],
                        ]
    var datePickerView:UIDatePicker = UIDatePicker()
    var startMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var endMeetingTimePickerView:UIDatePicker = UIDatePicker()
    var capacityPicker = UIPickerView()
    var valueFromCapacityPicker = ""
    var locationPicker = UIPickerView()
    var valueFromLocationPicker = ""
    var capacityArray = ["1-5 people", "1-10 people", "1-20 people", "1-30 people","1-50 people","1-100 people"]
    var locationArray = ["1st Floor", "2nd Floor", "3rd Floor", "4th Floor", "5th Floor"]
    
    
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
    
  
    @IBAction func btnApplyFilter(_ sender: Any) {
        
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
            if(indexPath.row == 1)
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
            print("zero")
            
            datePickerView.datePickerMode = UIDatePickerMode.date
            cell?.txtField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(SEFilterViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
            
            let toolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.donePicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            
            cell?.txtField.inputAccessoryView = toolBar
            
        case  1:
            var startTimetoolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.donePicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            startTimetoolBar.tag = 20
            
            startMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            startMeetingTimePickerView.addTarget(self, action: #selector(SEFilterViewController.startTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            cell?.txtStartMeetingTime.inputView = startMeetingTimePickerView
            cell?.txtStartMeetingTime.inputAccessoryView = startTimetoolBar
            
            
            var endTimetoolBar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.donePicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            endTimetoolBar.tag = 30
            
            endMeetingTimePickerView.datePickerMode = UIDatePickerMode.time
            endMeetingTimePickerView.addTarget(self, action: #selector(SEFilterViewController.endTimePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            cell?.txtEndMeetingTime.inputView = endMeetingTimePickerView
            cell?.txtEndMeetingTime.inputAccessoryView = endTimetoolBar
            
        case  2:
            print("zero")
            var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.donePicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            cell?.txtField.inputView = capacityPicker
            cell?.txtField.inputAccessoryView = toolbar

        case  3:
            print("zero")
             var toolbar = UIToolbar().ToolbarPiker(doneSelect: #selector(SEFilterViewController.donePicker), cancelSelect: #selector(SEFilterViewController.cancelPicker))
            cell?.txtField.inputView = locationPicker
            cell?.txtField.inputAccessoryView = toolbar

        default:
            break
        }
        
        return cell!
    }
    
    
    
    @objc func startTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
       let startMeetingTime = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func endTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        let endMeetingTime = dateFormatter.string(from: sender.date)
        
       }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        var dateFromDatePicker = dateFormatter.string(from: sender.date)
    }
    
    @objc func donePicker(sender: Any) {
//        self.tblCreateEvent.reloadData()
        print("tag : \((sender as AnyObject).tag)")
        view.endEditing(true)
    }
    
    @objc func cancelPicker(sender: Any) {
        print("tag : \((sender as AnyObject).tag)")
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
            valueFromCapacityPicker = self.capacityArray[row]
        }
        else{
            valueFromLocationPicker = self.locationArray[row]
        }
    }
    
}
