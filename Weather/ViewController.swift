//
//  ViewController.swift
//  Weather
//
//  Created by Ibrahim Almakky on 16/11/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet var left: UISwipeGestureRecognizer!
    @IBOutlet var right: UISwipeGestureRecognizer!
    
    var locations:[Location] = []
    var weekDays:[String] = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var mainWeatherIcons: [String: String] = ["01d": "sunny", "02d": "sunny_to_cloudy", "03d": "overcast", "04d": "overcast", "09d": "heavy_rain", "10d": "sun_rain", "11d": "thunder", "13d": "snowy", "50d": "fog", "01n": "full_moon", "02n": "", "03n": "overcast", "04n": "overcast", "09n": "heavy_rain", "10n": "showers", "11n": "thunder", "13n": "snowy", "50n": "fog"]
    var weatehrInfo = [WeatherInfo]()
    var threads:Int = 0
    var img = UIImage(named: "heavy_rain")
    var weekDay:Int = 0
    var dayornight:Int = 1
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.getLocations()

        // Hide the content when the app starts until the data loads
        self.weatherTable.alpha = 0.0
        self.mainWeatherImage.alpha = 0.0
        self.currentTempLabel.alpha = 0.0
        self.locationLabel.alpha = 0.0
        
        // Adding gestures for swiping left and right
        self.view.addGestureRecognizer(self.right)
        self.view.addGestureRecognizer(self.left)
        
        // Page indicator
        self.pageController.numberOfPages = locations.count
        self.pageController.currentPage = 0
        
        self.getWeather()
        self.getDay()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        weatherTable.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: "reloadMain", object: nil)

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
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        println("swipeLeft")
        if self.pageController.currentPage < self.pageController.numberOfPages - 1{
            UIView.animateWithDuration(1.0, animations: {
                println("animate")
                self.weatherTable.alpha = 0.0
                self.mainWeatherImage.alpha = 0.0
                self.currentTempLabel.alpha = 0.0
                self.locationLabel.alpha = 0.0
                }, completion: {
                    (value: Bool) in
                    self.pageController.currentPage++
                    println("page: \(self.pageController.currentPage)")
                    self.setMain()
                    self.getWeather()
            })
        }
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        println("swipeRight")
        if self.pageController.currentPage > 0 {
            UIView.animateWithDuration(1.0, animations: {
                println("animate")
                self.weatherTable.alpha = 0.0
                self.mainWeatherImage.alpha = 0.0
                self.currentTempLabel.alpha = 0.0
                self.locationLabel.alpha = 0.0
                }, completion: {
                    (value: Bool) in
                    self.pageController.currentPage--
                    println("page: \(self.pageController.currentPage)")
                    self.setMain()
                    self.getWeather()
            })
        }
    }
    
    func getWeather() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.threads++
        let location = "\(self.locations[self.pageController.currentPage].city),\(self.locations[self.pageController.currentPage].country)"
        Weather.getWeather(location, completion: {(result: Array<WeatherInfo>) in
            self.weatehrInfo = result
            dispatch_async(dispatch_get_main_queue(), {
                self.weatherTable.reloadData()
                self.threads--
                if(self.threads == 0) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.setMain()
                }
                UIView.animateWithDuration(1.0, animations: {
                    self.weatherTable.alpha = 1.0
                    self.mainWeatherImage.alpha = 1.0
                    self.currentTempLabel.alpha = 1.0
                    self.locationLabel.alpha = 1.0
                })
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
        self.locationLabel.text = locations[self.pageController.currentPage].city
        self.currentTempLabel.text = "\(self.weatehrInfo[self.pageController.currentPage].dayTemp)°"
        if (Array(weatehrInfo[0].iconCode)[Array(weatehrInfo[0].iconCode).count-1] == "d") {
//            println("Day")
            self.dayornight = 1
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "clearSky.jpg")!)
        } else if (Array(weatehrInfo[0].iconCode)[Array(weatehrInfo[0].iconCode).count-1] == "n") {
//            println("Night")
            self.dayornight = 0
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        }
        if let mainIconName = mainWeatherIcons.indexForKey(weatehrInfo[0].iconCode) {
//            println(mainWeatherIcons[mainIconName].1)
            self.mainWeatherImage.image = UIImage(named: "\(mainWeatherIcons[mainIconName].1)")
        }
    }
    
    func getLocations() {
        let fetchRequest = NSFetchRequest(entityName: "Location")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Location] {
            self.locations = fetchResults
            println("locations.count=\(locations.count)")
        }
    }
    
    func reload(notification: NSNotification) {
        self.getLocations()
        
        // Hide the content when the app starts until the data loads
        self.weatherTable.alpha = 0.0
        self.mainWeatherImage.alpha = 0.0
        self.currentTempLabel.alpha = 0.0
        self.locationLabel.alpha = 0.0
        
        // Page indicator
        self.pageController.numberOfPages = locations.count
        self.pageController.currentPage = 0
        
        self.getWeather()
        self.getDay()
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

