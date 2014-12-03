//
//  Suggestions.swift
//  Weather
//
//  Created by Ibrahim Almakky on 02/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import Foundation

struct Suggestion{
    var id: Int
    var name: String
    var country: String
}

class Suggestions {
    
    class func getSuggestions(searchString: String, completion: Array<Suggestion>->()) {
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/find?q=\(searchString)&mode=json&type=like&cnt=10")
        if let tempURL:NSURL = url {
            let urlReq = NSURLRequest(URL: tempURL)
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(urlReq, queue: queue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if (error != nil) {
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
                        var suggestionsArray = [Suggestion]()
                        var suggestionsNum = 0
                        for suggestion in list {
                            var OneSuggestion = Suggestion(id: 0, name: "", country: "")
                            if let name: String = suggestion["name"] as? String {
                                OneSuggestion.name = name
                            }
                            if let id: Int = suggestion["id"] as? Int {
                                OneSuggestion.id = id
                            }
                            if let sys:NSDictionary = suggestion["sys"] as? NSDictionary {
                                if let country:String = sys["country"] as? String {
                                    OneSuggestion.country = country
                                }
                            }
                            suggestionsArray.append(OneSuggestion)
                            suggestionsNum++
                        }
                        completion(suggestionsArray)
                    }
                }
            })
        }
    }
}
