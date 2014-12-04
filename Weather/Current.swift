//
//  Current.swift
//  Weather
//
//  Created by Ibrahim Almakky on 03/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var id:String
    var city:String
    var country:String
    var temp_min:Int
    var temp_max:Int
    var icon:String
    var iconImg: UIImage
}

class CurrentWeather {
    
    class func getCurrents(ids: Array<String>, completion: Array<Current>->()) {
        var idString:String = ids[0]
        for (var i=1 ; i<(ids.count); i++) {
            idString = idString+","+ids[i]
            println(idString)
        }
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/group?id=\(idString)&units=metric")
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
                        var newCurrents = [Current]()
                        var idsNum = 0
                        for id in list {
                            var newCurrent = Current(id: "", city: "", country: "", temp_min: 0, temp_max: 0, icon: "", iconImg: UIImage())
                            if let id:Int = id["id"] as? Int {
                                newCurrent.id = "\(id)"
                            }
                            if let sys:NSDictionary = id["sys"] as? NSDictionary {
                                if let country:String = sys["country"] as? String {
                                    newCurrent.country = country
                                }
                            }
                            if let name:String = id["name"] as? String {
                                newCurrent.city = name
                            }
                            if let main:NSDictionary = id["main"] as? NSDictionary {
                                if let temp_min:Int = main["temp_min"] as? Int {
                                    newCurrent.temp_min = temp_min
                                }
                                if let temp_max:Int = main["temp_max"] as? Int {
                                    newCurrent.temp_max = temp_max
                                }
                            }
                            if let weather:Array<AnyObject> = id["weather"] as? Array<AnyObject> {
                                if let weather0:NSDictionary = weather[0] as? NSDictionary {
                                    if let icon:String = weather0["icon"] as? String {
                                        println("IconCode= \(icon)")
                                        newCurrent.icon = icon
                                        let iconURL = NSURL(string: "http://openweathermap.org/img/w/\(icon).png")
                                        if let iconData = NSData(contentsOfURL: iconURL!) {
                                            if let image:UIImage = UIImage(data: iconData) {
                                                newCurrent.iconImg = image
                                            }
                                        }
                                    }
                                }
                            }
                            newCurrents.append(newCurrent)
                            idsNum++
                        }
                        completion(newCurrents)
                    }
                }
            })
        }
    }
}
