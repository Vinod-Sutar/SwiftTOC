//
//  HTTPRequestManager.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class HTTPRequestManager: NSObject {

    
    
    func sendRequest(_ requestURL: URL) {

        let config: URLSessionConfiguration = URLSessionConfiguration.default
        
        config.requestCachePolicy = .reloadIgnoringLocalCacheData;
        
        config.timeoutIntervalForRequest = 30;
        
        let session: URLSession = URLSession(configuration: config)
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        
        request.setValue("urn:CMSoverviewAppRequestHandler", forHTTPHeaderField: "namespace")
        
        request.setValue("generateAllFiles", forHTTPHeaderField: "message")
        
        request.setValue("text/xml; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        request.setValue("urn:CMSoverviewAppRequestHandler#generateAllFiles", forHTTPHeaderField: "SOAPAction")

        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns6280:generateAllFiles xmlns:ns6280=\"http://tempuri.org\"><Data xsi:type=\"xsd:string\">{&quot;unique_id&quot;:&quot;ENAS8093&quot;}</Data></ns6280:generateAllFiles></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        request.setValue("\(paramString.lengthOfBytes(using: String.Encoding.utf8))", forHTTPHeaderField: "Content-Length")

        let task = session.dataTask(with: requestURL, completionHandler: {(data, response, error) -> Void in
            
            if error == nil
            {
                if data == nil {
                    
                    print("Data nil received")
                }
                else {
                    
                    let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("Data received: \(datastring!)")
                }
            }
            else {
                
                print("Error: \(error?.localizedDescription)")
            }
            
        })
        
        task.resume()
        
    }
}
