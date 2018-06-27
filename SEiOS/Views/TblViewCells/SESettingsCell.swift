//
//  SESettingsCell.swift
//  SEiOS
//
//  Created by shekhar gaur on 27/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SESettingsCell: UITableViewCell {

    @IBOutlet weak var lblTitile: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblValue.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
