//
//  AddLocationViewController.swift
//  Weather
//
//  Created by Ibrahim Almakky on 01/12/2014.
//  Copyright (c) 2014 Ibrahim Almakky. All rights reserved.
//

import UIKit
import Foundation

class AddLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestedLocationsTable: UITableView!
    
    var suggestions = [Suggestion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.suggestedLocationsTable.dataSource = self
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
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestedLocationCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = "Hello"
        return cell
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        println(suggestions)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getSuggestions() {
        Suggestions.getSuggestions("dew", completion: {(result: Array<Suggestion>) in
            println(result)
            self.suggestions = result
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
