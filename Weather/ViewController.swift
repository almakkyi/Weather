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
    var weatehrInfo = [WeatherInfo]()
    var threads:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWeather()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatehrInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as UITableViewCell
        //cell.textLabel.text = "Hello"
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
                }
            })
        })
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

