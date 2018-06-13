//
//  SECreateEventTableViewCell.swift
//  SEiOS
//
//  Created by Harish Rathuri on 13/06/18.
//  Copyright © 2018 InfoVision Labs India Pvt. Ltd. All rights reserved.
//

import UIKit

class SECreateEventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
