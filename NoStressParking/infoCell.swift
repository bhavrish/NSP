//
//  infoCell.swift
//  NoStressParking
//
//  Created by Bhavesh Shah on 11/10/18.
//  Copyright © 2018 Bhavesh Shah. All rights reserved.
//

import UIKit

class infoCell: UITableViewCell {

    @IBOutlet weak var timingsLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var probabilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
