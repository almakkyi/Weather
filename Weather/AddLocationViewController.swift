//
//  AddLocationViewController.swift
//  Weather
//
//  Created by Ibrahim Almakky on 01/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestedLocationsTable: UITableView!
    
    var suggestions = [Suggestion]()
    var threads:Int = 0
    var searchString: String = ""
    
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
        
        self.searchBar.delegate = self
        self.suggestedLocationsTable.delegate = self
        self.suggestedLocationsTable.dataSource = self
        
        self.getSuggestions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestedLocationCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = "\(suggestions[indexPath.row].name), \(suggestions[indexPath.row].country)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        self.addItem("\(suggestions[indexPath.row].id)", city: suggestions[indexPath.row].name, country: suggestions[indexPath.row].country)
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(self.searchBar.text)
        self.searchString = self.searchBar.text
        if(searchString != "") {
            getSuggestions()
        }
    }
    
    func getSuggestions() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.threads++
        Suggestions.getSuggestions(searchString, completion: {(result: Array<Suggestion>) in
            self.suggestions = result
            dispatch_async(dispatch_get_main_queue(), {
                self.suggestedLocationsTable.reloadData()
                self.threads--
                if (self.threads == 0) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        })
    }
    
    func addItem(id: String, city:String, country:String) {
        let newLocation:Location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: self.managedObjectContext!) as Location
        newLocation.id = id
        newLocation.city = city
        newLocation.country = country
        println("Location Added: id=\(id), city=\(city), country=\(country)")
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
