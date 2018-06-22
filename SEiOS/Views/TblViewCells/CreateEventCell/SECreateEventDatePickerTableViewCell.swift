//
//  SECreateEventTableViewCell.swift
//  SEiOS
//
//  Created by Harish Rathuri on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SECreateEventDatePickerTableViewCell : UITableViewCell
{
    
    @IBOutlet weak var customeDatePickerView: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var imgageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

