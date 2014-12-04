//
//  Current.swift
//  Weather
//
//  Created by Ibrahim Almakky on 03/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import Foundation

struct Current {
    var id:String
    var city:String
    var country:String
    var temp_min:Int
    var temp_max:Int
    var icon:String
}

class CurrentWeather {
    class func getCurrent(id: String, completion: Current->()) {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/group?id=\(id)&units=metric")
        if let tempURL:NSURL = url {
            let urlReq = NSURLRequest(URL: tempURL)
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(urlReq, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (error != nil) {
                    //println("2")
                    println("API error: \(error), \(error.userInfo)")
                }
                
                var jsonError:NSError?
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                if(jsonError != nil) {
                    println("Error parsing json: \(jsonError)")
                } else {
                    if let status:String = json["status"] as? String {
                        println("Server Status: \(status)")
                    }
                    
                    if let list:Array<AnyObject> = json["list"] as? Array<AnyObject> {
                        let listObject: AnyObject = list[0] as AnyObject
                        var newCurrent = Current(id: "", city: "", country: "", temp_min: 0, temp_max: 0, icon: "")
                        if let id:Int = listObject["id"] as? Int {
                            newCurrent.id = "\(id)"
                        }
                        if let sys:NSDictionary = listObject["sys"] as? NSDictionary {
                            if let country:String = sys["country"] as? String {
                                newCurrent.country = country
                            }
                        }
                        if let name:String = listObject["name"] as? String {
                            newCurrent.city = name
                        }
                        if let main:NSDictionary = listObject["main"] as? NSDictionary {
                            if let temp_min:Int = main["temp_min"] as? Int {
                                newCurrent.temp_min = temp_min
                            }
                            if let temp_max:Int = main["temp_max"] as? Int {
                                newCurrent.temp_max = temp_max
                            }
                        }
                        if let weather:Array<AnyObject> = listObject["weather"] as? Array<AnyObject> {
                            if let weather0:NSDictionary = weather[0] as? NSDictionary {
                                if let icon:String = weather0["id"] as? String {
                                    newCurrent.icon = icon
                                }
                            }
                        }
                        completion(newCurrent)
                    }
                }
            })
        }
    }
}
