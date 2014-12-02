//
//  WeatherFeed.swift
//  Weather
//
//  Created by Ibrahim Almakky on 16/11/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import Foundation
import UIKit

struct WeatherInfo {
    var location:String
    var day:Int
    var date:NSDate
    var dayTemp:Int
    var minTemp:Int
    var maxTemp:Int
    var nightTemp:Int
    var eveTemp:Int
    var mornTemp:Int
    var main:String
    var description:String
    var icon:UIImage
    var iconCode:String
}

class Weather {
    
    class func getWeather(location:String, completion:Array<WeatherInfo>->()) {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(location)&mode=json&units=metric&cnt=10")
//        println("url = \(url)")
        if let tempURL:NSURL = url {
            //println("1")
            let urlReq = NSURLRequest(URL: tempURL)
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(urlReq, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (error != nil) {
                    //println("2")
                    println("API error: \(error), \(error.userInfo)")
                }
                //println("3")
                var jsonError:NSError?
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                if(jsonError != nil) {
                    println("Error parsing json: \(jsonError)")
                } else {
                    if let status:String = json["status"] as? String {
                        println("Server Status: \(status)")
                    }
                    
                    if let days:Array<AnyObject> = json["list"] as? Array<AnyObject> {
                        var weatherArray = [WeatherInfo]()
                        var daysNum = 0
                        for day in days {
                            var WeatherDay = WeatherInfo(location: "", day: daysNum, date: NSDate(), dayTemp: 0, minTemp: 0, maxTemp: 0, nightTemp: 0, eveTemp: 0, mornTemp: 0, main: "", description: "", icon: UIImage(), iconCode: "")
                            //println(daysNum)
                            if let timeStamp:Int = day["dt"] as? Int {
                                //println("\(daysNum): \(timeStamp)")
                                var formatter:NSDateFormatter = NSDateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy hh:mm"
                                let interval:NSTimeInterval = Double(timeStamp)
                                let date:NSDate = NSDate(timeIntervalSince1970: interval)
                                let dateString = formatter.stringFromDate(date)
                                WeatherDay.date = date
                                //println("\(daysNum): \(dateString)")
                            }
                            if let temp:NSDictionary = day["temp"] as? NSDictionary {
                                //println("\(daysNum): \(temp)")
                                if let dayTemp:Int = temp["day"] as? Int {
                                    WeatherDay.dayTemp = dayTemp
                                }
                                if let minTemp:Int = temp["min"] as? Int {
                                    WeatherDay.minTemp = minTemp
                                }
                                if let maxTemp:Int = temp["max"] as? Int {
                                    WeatherDay.maxTemp = maxTemp
                                }
                                if let nightTemp:Int = temp["night"] as? Int {
                                    WeatherDay.nightTemp = nightTemp
                                }
                                if let eveTemp:Int = temp["eve"] as? Int {
                                    WeatherDay.eveTemp = eveTemp
                                }
                                if let mornTemp:Int = temp["morn"] as? Int {
                                    WeatherDay.mornTemp = mornTemp
                                }
                                if let weather:Array<AnyObject> = day["weather"] as? Array<AnyObject> {
                                    //println(weather)
                                    if let weather0:NSDictionary = weather[0] as? NSDictionary {
                                        //println(weather0)
                                        if let main:String = weather0["main"] as? String {
                                            WeatherDay.main = main
                                        }
                                        if let description:String = weather0["description"] as? String {
                                            WeatherDay.description = description
                                        }
                                        if let icon:String = weather0["icon"] as? String {
                                            WeatherDay.iconCode = icon
                                            let iconURL = NSURL(string: "http://openweathermap.org/img/w/\(icon).png")
                                            if let iconData = NSData(contentsOfURL: iconURL!) {
                                                if let image:UIImage = UIImage(data: iconData) {
                                                    WeatherDay.icon = image
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            weatherArray.append(WeatherDay)
                            daysNum++
                        }
                        completion(weatherArray)
                    }
                }
            })
        }
    }
}