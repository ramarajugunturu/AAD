//
//  SEAttendeesListCell.swift
//  SEiOS
//
//  Created by Shekhar Gaur on 15/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SEAttendeesListCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(name: String) {
        self.lblUsername.text = name
    }

}
