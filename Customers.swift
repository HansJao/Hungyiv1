//
//  Customers.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/20.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit

class Customers {
    var CustomerId = ""
    var CustomerName = ""
    var IsChecked = false
    var ProductArray = [Products]()
    
    
    init(ID:String,Name:String)
    {
        self.CustomerId=ID
        self.CustomerName=Name

    }

}
