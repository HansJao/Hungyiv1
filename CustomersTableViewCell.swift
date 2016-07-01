//
//  CustomersTableViewCell.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/20.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit

class CustomersTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var idLabel:UILabel!
    @IBOutlet var productNameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
