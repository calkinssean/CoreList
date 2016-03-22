//
//  TaskTableViewCell.swift
//  CoreList
//
//  Created by Sean Calkins on 3/22/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
