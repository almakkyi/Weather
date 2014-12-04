//
//  LocationsViewController.swift
//  Weather
//
//  Created by Ibrahim Almakky on 01/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit
import CoreData

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var locationsTable: UITableView!
    
    var locations = [Location]()
    var detailedLocation = [Current]()
    var locationsIDs = [String]()
    var threads:Int = 0
    var img = UIImage(named: "heavy_rain")
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable:", name: "reload", object: nil)
        
        self.locationsTable.dataSource = self
        
        self.getLocations()
        self.getDetailedLocations()
//        println(self.detailedLocation)
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        locationsTable.registerNib(nib, forCellReuseIdentifier: "customCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMain", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedLocation.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as UITableViewCell
//        cell.textLabel.text = self.detailedLocation[indexPath.row].city
//        cell.textLabel.text = self.detailedLocation[0].main
//        cell.textLabel.text = "Hello"
        var cell:CustomTableViewCell = self.locationsTable.dequeueReusableCellWithIdentifier("customCell") as CustomTableViewCell
        cell.loadItem(self.detailedLocation[indexPath.row].city, icon: self.detailedLocation[indexPath.row].iconImg, maxTemp: self.detailedLocation[indexPath.row].temp_max, minTemp: self.detailedLocation[indexPath.row].temp_min)
        
        return cell
    }
    
    func getLocations() {
        let fetchRequest = NSFetchRequest(entityName: "Location")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Location] {
            self.locations = fetchResults
            println("locations.cou  nt=\(locations.count)")
        }
    }
    
    func getDetailedLocations() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.threads++
        self.getIds()
        CurrentWeather.getCurrents(locationsIDs, completion: {(result: Array<Current>) in
            self.detailedLocation = result
            dispatch_async(dispatch_get_main_queue(), {
                self.locationsTable.reloadData()
                self.threads--
                if(self.threads == 0) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        })
    }
    
    func reloadTable(notification: NSNotification){
        self.getLocations()
        self.getDetailedLocations()
        println(self.detailedLocation.count)
        self.locationsTable.reloadData()
    }
    
    func getIds() {
        locationsIDs = []
        for location in locations {
            self.locationsIDs.append(location.id)
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
