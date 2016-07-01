//
//  ViewController.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/13.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var AllCustomers:[Customers]!
    
    var SelectCustomers = [Customers]()
    //let ConnectToServer = HttpRequest(ActionMethod: "GetCustomerData", BarCode: "Test")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllCustomers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier="Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomersTableViewCell
        cell.nameLabel.text = AllCustomers[indexPath.row].CustomerName
        if(AllCustomers[indexPath.row].IsChecked){
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        return cell
    }
    // Step-1 取得點到的row
    // Step-2 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)

        
        let mycell = tableView.cellForRowAtIndexPath(indexPath)
        if AllCustomers[indexPath.row].IsChecked == false
        {

            SelectCustomers.append( AllCustomers[indexPath.row])
            
            AllCustomers[indexPath.row].IsChecked = true
            mycell?.accessoryType = .Checkmark
        }
        else
        {
            var CountIndex:Int = 0
            for SelectCustomer in SelectCustomers
            {
                if SelectCustomer.CustomerId==AllCustomers[indexPath.row].CustomerId
                {
                    SelectCustomers.removeAtIndex(CountIndex)
                }
                CountIndex += 1
            }
            
            AllCustomers[indexPath.row].IsChecked = false
            mycell?.accessoryType = .None
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showProductTable"
        {
            for Customer in AllCustomers
            {
                Customer.IsChecked = false
            }
            let destinationController = segue.destinationViewController as! ProductViewController
            destinationController.AllCustomers = SelectCustomers
            
        }
        
    }

    
    


}

