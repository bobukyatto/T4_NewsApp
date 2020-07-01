//
//  HTTP.swift
//  P9a_NewsApp2
//
//  Created by KIM FOONG CHOW on 7/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

///
/// A simple wrapper for Http functions
///
class HTTP: NSObject {
    /**
     Issues a HTTP request to the server
     */
    private class func request(
        url: String,
        httpMethod : String,
        httpHeaders : [String: String],
        httpBody : Data?,
        onComplete: ((_: Data?, _: URLResponse?, _: Error?) -> Void)?) {
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        for (key, value) in httpHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in onComplete?(data, response, error)
        }.resume()
    }
    
    /**
     Issues a HTTP request to the server
     */
    private class func requestJSON(
        url: String,
        httpMethod : String,
        json: JSON?,
        onComplete: ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?) {
        do {
            var httpBody : Data?
            
            if (json != nil) {
                httpBody = try json!.rawData()
            }
            
            request(
                url: url,
                httpMethod: httpMethod,
                httpHeaders: [
                    "Accept" : "application/json",
                    "Content-Type" : "application/json"
                ],
                httpBody: httpBody,
                onComplete: {
                    data, response, error in var result : JSON?
                    
                    if (data != nil) {
                        result = JSON.init(data: data!)
                    }
                    
                    onComplete?(result, response, error)
            })
        }
        catch {}
    }
    
    /**
     Issues a HTTP GET request to the server.
     Retrieves the result as a SwiftyJSON object.
     */
    class func getJSON(url: String, onComplete: ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?) {
        requestJSON(
            url: url,
            httpMethod: "GET",
            json: nil,
            onComplete: onComplete
        )
    }
    
    /**
     Issues a HTTP POST request to the server using a SwiftyJSON
     Object as the POST parameters.
     Retrieves the result as a SwiftyJSON object.
     */
    class func postJSON(url: String, json: JSON, onComplete: ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?) {
        requestJSON(
            url: url,
            httpMethod: "POST",
            json: json,
            onComplete: onComplete
        )
    }
    
    /**
     Downloads an image from the internet
    */
    class func downloadImage(url: String, onComplete: ((_: UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .background).async
        {
            // The following downloads data from the internet
            // The downloaded data should represent an image in the
            // JPG, GIF, PNG or any compatible format
            let nUrl = URL(string: url)
            var imageBinary : Data?
            if nUrl != nil {
                do {
                    imageBinary = try Data(contentsOf: nUrl!)
                }
                catch {
                    return
                }
            }
            
            // After retrieving the image data, convert
            // it to a UIImage object
            var img: UIImage?
            if imageBinary != nil {
                img = UIImage(data: imageBinary!)
            }
            
            DispatchQueue.main.async
            {
                // Call the onComplete closure so that the
                // caller can display it in the user interface
                onComplete?(img)
            }
        }
    }
}

