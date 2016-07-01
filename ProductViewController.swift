//
//  ProductViewController.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/23.
//  Copyright © 2016年 Hans. All rights reserved.
//
import AVFoundation
import UIKit

class ProductViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var ProductTableView: UITableView!
    @IBOutlet weak var BarCodeView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let ConnectToServer = HttpRequest()
    
    var IndexOfCustomersSection: Int = 0
    
    var AllCustomers = [Customers]()
    //Step-1 建立TableView樣式與資料

    override func viewDidLoad() {
        super.viewDidLoad()
        //Step-1 建立TableView樣式與資料
         ProductTableView.delegate = self
         ProductTableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    //Step-2 取得裝置相機使用
    //Step-3 設置相機顯示畫面位置與大小
    //Step-4 run Camara
    @IBAction func RunBarCodeScane()
    {
        //Stpe-2 取得裝置相機使用
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch
        {
            return
        }
        
        //取用相機
        if (captureSession.canAddInput(videoInput))
        {
            captureSession.addInput(videoInput)
        }
        else
        {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        //Step-3 設置相機顯示畫面位置與大小
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = CGRectMake(0, 0, BarCodeView.frame.width,BarCodeView.frame.height);
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        BarCodeView.layer.addSublayer(previewLayer)
        
        //Step-4 run Camara
        captureSession.startRunning();
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false)
        {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true)
        {
            captureSession.stopRunning();
        }
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    //獲取條碼資訊
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first
        {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue );
        }
    }
    
    
    //Step-1 取得SQL資料
    //Step-2 檢查Product是否有重覆掃過
    //Stpe-3 資料置於Customers
    //Step-4 防止怪怪的Error 並重新載入TableView
    func foundCode(code: String )
    {
        //Step-1 傳入條碼號並取得SQL資料
        ConnectToServer.makeRequest(code)
        {
            (data) ->  Void in
            print("response data:\(data)")
            var CanIntoAllCustomers:Bool = true
            //Step-2 檢查Product是否有重覆掃過 若無則Step-3 否Skip Step-3 and Step-4
            for Cells in self.AllCustomers
            {
                for Products in Cells.ProductArray
                {
                    if Products.ProductID == self.ConnectToServer.ProductsArray[0].ProductID
                    {
                        CanIntoAllCustomers = false
                    }
                }
            }
            //Stpe-3 資料置於Customers
            if CanIntoAllCustomers == true
            {
                self.AllCustomers[self.IndexOfCustomersSection].ProductArray += self.ConnectToServer.ProductsArray
                //Step-4 防止怪怪的Error 並重新載入TableView
                dispatch_async(dispatch_get_main_queue(), {
                    self.ProductTableView.reloadData()
                })
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    //顯示Section title 的資料
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return AllCustomers[section].CustomerName
//        
//    }
//    
    
    //計算有幾個Section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return AllCustomers.count
    }
    
    //計算每一個Section有幾個row
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return AllCustomers[section].ProductArray.count
        return AllCustomers[section].ProductArray.count + 1
    }
    
    // 回傳Customer內容
    func GetCustomerBySection(indexPath:NSIndexPath)->Customers
    {
        return AllCustomers[indexPath.section]
    }
    
    //Step-1 取出AllCustomers各個Section的內容
    //Step-2 此Customer已有商品且要跑到第二次後 -> Step-2.1(indexPath.row>0) else Step-3
    //Step-2.1 加入商品Row
    //Step-3 加入客戶 Row
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
     {
        //Step-1 取出AllCustomers各個Section的內容
        let CustomerDetail = GetCustomerBySection(indexPath)
        let cellIdentifier="Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomersTableViewCell
        //Step-2 此Customer已有商品且要跑到第二次後才能進來(indexPath.row>0)
        if CustomerDetail.ProductArray.count > 0 && indexPath.row > 0
        {

        //Step-2.1 加入商品Row
            cell.productNameLabel.text = CustomerDetail.ProductArray[indexPath.row-1].ProductName
            cell.nameLabel.text = ""
        }
        else
        {
        //Step-3 加入客戶 Row
            cell.productNameLabel.text = ""
            cell.nameLabel.text = CustomerDetail.CustomerName
        }
        
        if CustomerDetail.IsChecked
        {
            cell.accessoryType = .Checkmark
        }
        else
        {
            cell.accessoryType = .None
        }
        return cell
    }
    //Step-1 取得Select到的row
    //Stpe-2 利用Section決定Product要放在哪一位Customer身上
    //Step-3 將所有的CheckMark設為false
    //Step-3.1 同Step-3
    //Step-3.2 將Select到的Row Checkmark
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        ProductTableView!.deselectRowAtIndexPath(indexPath, animated: true)

        //Step-1 取得Select到的row
        let mycell = tableView.cellForRowAtIndexPath(indexPath)
        
        //Stpe-2利用Section決定Product要放在哪一位Customer身上
        IndexOfCustomersSection = indexPath.section

        for Customer in AllCustomers
        {
        //Step-3 將所有的CheckMark設為false
            Customer.IsChecked = false
        }

        //Step-3.1 同Step-3
        for testcell in ProductTableView.visibleCells
        {
            testcell.accessoryType = .None
        }
        //Step-3.2 將Select到的Row Checkmark
        AllCustomers[indexPath.section].IsChecked = true
        mycell?.accessoryType = .Checkmark


        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    //滑动删除必须实现的方法
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row > 0
        {
            AllCustomers[indexPath.section].ProductArray.removeAtIndex(indexPath.row - 1)
            ProductTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
        else
        {
           // AllCustomers.removeAtIndex(indexPath.section)
        }

        
    }
    
    //滑动删除
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    
    //修改删除按钮的文字
    func tableView(tableView: UITableView,titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath)-> String?
    {
        return "删"
    }
    
/*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showProductTable"
        {
            let destinationController = segue.destinationViewController as! ProductViewController
           // destinationController.AllCustomers=ConnectToServer.AllCustomers
            
        }

    }
    
*/
}
