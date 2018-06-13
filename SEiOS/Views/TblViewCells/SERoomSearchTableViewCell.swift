//
//  SERoomSearchTableViewCell.swift
//  SEiOS
//
//  Created by Rama Raju Gunturu on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SERoomSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var confRoomTitleLbl: UILabel!
    @IBOutlet weak var roomCapacityCount: UILabel!
    
    @IBOutlet weak var confRoomImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
