//
//  ServiceCalls.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 15/08/21.
//
import UIKit
import Foundation


class WebService {
    
    
    static func callGetAPI(url: URL, headers:[String:String], success: @escaping ((Any)->Void), failure: @escaping ((Error)->Void) ){
        print("URL:\(url.absoluteString)")
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 120.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("\(String(describing: error))")
                failure(error!)
                
            } else {
                let str = String.init(data: data!, encoding: .utf8)
                print("str = \(String(format: "%@", str!))")
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        DispatchQueue.main.async {
                            success(json)
                        }
                    }
                } catch let parseError {
                    DispatchQueue.main.async {
                        failure(parseError)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    static func callPostAPI(url: URL, headers:[String:String],param:[String:Any], success: @escaping ((Any)->Void), failure: @escaping ((Error)->Void) ){
        print("URL:\(url.absoluteString)")
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: param, options: [])
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 120.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("\(String(describing: error))")
                    failure(error!)
                    
                } else {
                    let str = String.init(data: data!, encoding: .utf8)
                    print("str = \(String(format: "%@", str!))")
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                            DispatchQueue.main.async {
                                success(json)
                            }
                        }
                    } catch let parseError {
                        DispatchQueue.main.async {
                            failure(parseError)
                        }
                    }
                }
            })
            
            dataTask.resume()
            
            
        } catch let err {
            failure(err)
        }
        
    }

}
