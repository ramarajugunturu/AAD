//
//  SECreateEventViewController.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SECreateEventViewController: SEBaseViewController {

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

    @IBOutlet weak var btnCreateEvent: UIButton!
    
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

    }
    
    @IBAction func testButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "event2RoomSearch", sender: nil)
    }

}

extension SECreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
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
        cell?.imageView?.contentMode = .scaleAspectFit
        cell?.lblTitle.text = titleStr
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        /*
//        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//        UIButton *addcharity=[UIButton buttonWithType:UIButtonTypeCustom];
//        [addcharity setTitle:@"Add to other" forState:UIControlStateNormal];
//        [addcharity addTarget:self action:@selector(addCharity:) forControlEvents:UIControlEventTouchUpInside];
//        [addcharity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];  //Set the color this is may be different for iOS 7
//        addcharity.frame=CGRectMake(0, 0, 130, 30); //Set some large width for your title
//        [footerView addSubview:addcharity];
//        return footerView;
//        */
//        
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//        footerView.backgroundColor = UIColor.clear
//        
//        
//        footerView.addSubview(self.btnCreateEvent)
//        
//        return footerView
//        
//    }
//    
}
