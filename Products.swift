//
//  Products.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/24.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit

class Products {
    var ProductID = ""
    var ProductName = ""
    var TextileColor = ""
    var ProductWeight = ""
    var UnitPrice = 0
    
    init(ProductID:String, ProductName:String,TextileColor:String,ProductWeight:String)
    {
        self.ProductID = ProductID
        self.ProductName = ProductName
        self.TextileColor = TextileColor
        self.ProductWeight = ProductWeight
    }

}
