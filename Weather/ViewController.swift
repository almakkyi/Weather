//
//  ViewController.swift
//  Weather
//
//  Created by Ibrahim Almakky on 16/11/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var locations:[String] = ["Coventry,uk"]
    var weekDays:[String] = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var mainWeatherIcons: [String: String] = ["01d": "sunny", "02d": "sunny_to_cloudy", "03d": "overcast", "04d": "overcast", "09d": "heavy_rain", "10d": "sun_rain", "11d": "thunder", "13d": "snowy", "50d": "fog", "01n": "", "02n": "", "03n": "overcast", "04n": "overcast", "09n": "heavy_rain", "10n": "showers", "11n": "thunder", "13n": "snowy", "50n": "fog"]
    var weatehrInfo = [WeatherInfo]()
    var threads:Int = 0
    var img = UIImage(named: "heavy_rain")
    var weekDay:Int = 0
    var currentPage:Int = 0
    var dayornight:Int = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getWeather()
        self.getDay()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        weatherTable.registerNib(nib, forCellReuseIdentifier: "customCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatehrInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CustomTableViewCell = self.weatherTable.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        cell.loadItem(weekDays[(weekDay + indexPath.row)%7], icon: weatehrInfo[indexPath.row].icon, maxTemp: weatehrInfo[indexPath.row].maxTemp, minTemp: weatehrInfo[indexPath.row].minTemp)
        return cell
    }
    
    func getWeather() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.threads++
        let location = self.locations[0]
        Weather.getWeather(location, completion: {(result: Array<WeatherInfo>) in
            self.weatehrInfo = result
            dispatch_async(dispatch_get_main_queue(), {
                self.weatherTable.reloadData()
                self.threads--
                if(self.threads == 0) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.setMain()
                }
            })
        })
    }
    
    func getDay() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
        let weekday = components.weekday
        self.weekDay = weekday
    }
    
    func setMain() {
        self.locationLabel.text = locations[currentPage]
        self.currentTempLabel.text = "\(self.weatehrInfo[0].dayTemp)°"
        if (Array(weatehrInfo[0].iconCode)[Array(weatehrInfo[0].iconCode).count-1] == "d") {
            println("Day")
            self.dayornight = 1
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "clearSky.jpg")!)
        } else if (Array(weatehrInfo[0].iconCode)[Array(weatehrInfo[0].iconCode).count-1] == "n") {
            println("Night")
            self.dayornight = 0
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        }
        if let mainIconName = mainWeatherIcons.indexForKey(weatehrInfo[0].iconCode) {
            println(mainWeatherIcons[mainIconName].1)
            self.mainWeatherImage.image = UIImage(named: "\(mainWeatherIcons[mainIconName].1)")
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

