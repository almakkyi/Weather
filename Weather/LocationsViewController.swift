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
    
    var managedObjectContext:NSManagedObjectContext?

    @IBOutlet weak var locationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            self.managedObjectContext = context
            println(context)
        }
        self.locationsTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addLocation(sender: UIBarButtonItem) {
        println("addLocation")
    }
    
    func addItem(city:String, country:String) {
        let newLocation:Location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext!) as Location
        newLocation.city = city
        newLocation.country = country
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = "Hello"
        return cell
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
