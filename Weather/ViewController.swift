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
    var weatehrInfo = [WeatherInfo]()
    var threads:Int = 0
    var img = UIImage(named: "heavy_rain")
    var weekDay:Int = 0
    var currentPage:Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getWeather()
        self.getDay()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
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

