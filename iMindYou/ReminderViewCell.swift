//
//  ReminderViewCell.swift
//  iMindYou
//
//  Created by Rajagopal on 6/26/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import UIKit

class ReminderViewCell: UITableViewCell {

    // MARK Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
