//
//  FieldTableViewCell.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/20/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    var fieldID : String?;
    
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var lastVisitLabel: UILabel!
    @IBOutlet weak var acreSize: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func visitationReminderSwitch(sender: UISwitch) {
        print(sender.on, fieldID)
        
    }
}
