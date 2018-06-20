//
//  SECreateEventTableViewCell.swift
//  SEiOS
//
//  Created by Harish Rathuri on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SECreateEventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var switchToggleday: UISwitch!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblLine: UILabel!
    
    @IBOutlet weak var lblStartMeetingBottom: UILabel!
    @IBOutlet weak var lblEndMeetingBottom: UILabel!

    @IBOutlet weak var txtEndMeetingTime: UITextField!
    @IBOutlet weak var txtStartMeetingTime: UITextField!
    @IBOutlet weak var lblMeetingInterval: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAdd.isHidden = true
        switchToggleday.isHidden = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 15, width: 14, height: 14)
    }
}



//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
//        }
//    }
//}
