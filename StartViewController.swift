//
//  StartViewController.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/23.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    let ConnectToServer = HttpRequest()

    @IBAction func GetCustomerData()
    {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectToServer.GetCustomerData("GetCustomerData", BarCode: "Test")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCustomerTable"
        {
                let destinationController = segue.destinationViewController as! ViewController
                destinationController.AllCustomers=ConnectToServer.AllCustomers
            
        }

    }
    

}
