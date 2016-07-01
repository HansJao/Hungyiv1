//
//  HttpRequest.swift
//  Hungyiv1
//
//  Created by Hans on 2016/5/13.
//  Copyright © 2016年 Hans. All rights reserved.
//
import Foundation
import UIKit

class HttpRequest:NSObject ,NSXMLParserDelegate {
    
    var receiveIP:String = "192.168.16.147"
    override init()
    {
        
    }
//    init (ActionMethod:String,BarCode:String)
//    {
//        super.init()
//        let url:NSURL = NSURL(string: "http://"+receiveIP+"/HttpGetData/GetSqlData.aspx")!
//        let session = NSURLSession.sharedSession()
//        
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
//        
//        let paramString = "ActionMethod=\(ActionMethod)&ProductID=\(BarCode)"
//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
//        
//        let task = session.dataTaskWithRequest(request) 
//        {
//            (let data, let response, let error) in
//            
//            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else
//            {
//                print("error")
//                return
//            }
//            self.parserXML(data!)
//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print(dataString)
//        }
//        
//        task.resume()
//    }
    
    func GetCustomerData(ActionMethod:String,BarCode:String)
    {
        let url:NSURL = NSURL(string: "http://"+receiveIP+"/HttpGetData/GetSqlData.aspx")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "ActionMethod=\(ActionMethod)&ProductID=\(BarCode)"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request)
        {
            (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else
            {
                print("error")
                return
            }
            self.parserXML(data!)
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }
        
        task.resume()
    }
    
    var MyData = NSData()
    func GetProductData(ActionMethod:String,BarCode:String,ProductTableVie:UITableView)
    {
        let url:NSURL = NSURL(string: "http://"+receiveIP+"/HttpGetData/GetSqlData.aspx")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let paramString = "ActionMethod=\(ActionMethod)&ProductID=\(BarCode)"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithRequest(request,completionHandler:
        {
            (let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else
            {
                print("error")
                return
            }
            self.parserXML(data!)
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            self.MyData = data!
        })
        
        task.resume()
    }
    
    func httpGet(request: NSURLRequest!, callback: (NSString, NSString?) -> Void)
    {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil
            {
                callback("", error!.localizedDescription)
            }
            else
            {
                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                self.parserXML(data!)
                callback(result, nil)
            }
        }
        task.resume()
    }
    
    func makeRequest(barCode:String, callback: (NSString) ->Void) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://"+receiveIP+"/HttpGetData/GetSqlData.aspx")!)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let ExecptCheckCode = (barCode as NSString).substringToIndex(12)
        let paramString = "ActionMethod=GetProductData&ProductID=\(ExecptCheckCode)"
      //  request.setValue("application/XML", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        var result:NSString = ""
        
        httpGet(request)
        {
            (data, error) ->  Void in
            
            if error != nil {
                result = error!
            } else {
                result = data
            }
            callback(data)
        }
    }
    
    func parserXML(xml: NSData)
    {
        let xmlParser: NSXMLParser = NSXMLParser(data: xml)
        xmlParser.delegate = self
        
        xmlParser.parse()
        
    }
    var CombindCustomer:String?//組合customer資料
    
    var CustomerId:String = ""
    var CustomerName:String = ""
    var AllCustomers = [Customers]()
    
    var ProductID:String = ""
    var ProductName:String = ""
    var TextileColor:String = ""
    var ProductWeight:String = ""
    
    var ProductsArray = [Products]()
    

    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if(currentNodeName=="CustomerID")
        {
            CombindCustomer = ""
            CombindCustomer = string + ","
            CustomerId=string
        }
        
        if(currentNodeName=="CustomerName")
        {
            CustomerName=string

            AllCustomers.append(Customers(ID:CustomerId,Name: CustomerName))
            
        }
        
        switch currentNodeName {
        case "ProductID":
            ProductID = string
        case "ProductName":
            ProductName = string
        case "TextileColor":
            TextileColor = string
        case "ProductWeight":
            ProductWeight = string
            ProductsArray = [Products(ProductID:ProductID,ProductName: ProductName,TextileColor: TextileColor,ProductWeight: ProductWeight)]
        default:
            break
        }
    }
    
    var currentNodeName:String!
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentNodeName = elementName

    }



}
