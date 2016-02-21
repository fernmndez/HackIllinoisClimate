//
//  FieldTableViewController.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/20/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit
import CoreLocation;

class FieldTableViewController: UITableViewController, CLLocationManagerDelegate {

    var fields : [String: String]?;
    var keys : [String] = [];
    var acres : [Int] = [];
    var fieldId : [String] = [];
    var lastVisit : [Double] = [];
    
    static var insideGeofence : Bool = false;
    
    let locationManager = CLLocationManager() // Add this statement
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        if(!FieldTableViewController.insideGeofence){
            
        let refreshAlert = UIAlertController(title: "Inside Geofence!", message: "Location services has detected you are inside of your field : Siebel Center", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        self.lastVisit[4] = NSDate().timeIntervalSince1970;
        
        self.handleRefresh();
            FieldTableViewController.insideGeofence = true;
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        populateFields();
        
        
    }
    
    func loadLastVisits() {
        
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let visitsPath = rootPath.stringByAppendingString("/visits.plist")
        let lastVisitDictionary = NSMutableDictionary(contentsOfFile: visitsPath)!
        print(lastVisitDictionary)
        
        for _ in 0 ... 9001 {
            lastVisit.append(0.0);
        }
        

        
        handleRefresh();
        
    }

    func populateFields(){
        fields = [:];
        keys = [];
        acres = [];
        fieldId = [];
        
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let settingsPath = rootPath.stringByAppendingString("/settings.plist")
        let settingsDictionary = NSMutableDictionary(contentsOfFile: settingsPath)!
        let accessToken = settingsDictionary["token"]! as! String;
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://hackillinois.climate.com/api/fields?includeBoundary=false")!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
            
            for i: [String : AnyObject] in (jsonObject["fields"] as! Array)  {
                self.fields?.updateValue(i["id"] as! String, forKey: i["name"] as! String)
                self.keys += [i["name"] as! String]
                self.fieldId += [i["id"] as! String]
                self.acres += [i["area"]!["q"] as! Int]
                
                
                self.handleRefresh()
            }
            
            
        }           
        task.resume()
        
        loadLastVisits();
        
    }
    

    func handleRefresh() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        populateFields()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            refreshControl.endRefreshing()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.keys.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fieldTableViewCell", forIndexPath: indexPath) as! FieldTableViewCell
        
        cell.fieldID = fieldId[indexPath.row]
        cell.fieldNameLabel.text = keys[indexPath.row];
        cell.acreSize.text = "Acres : " + acres[indexPath.row].description;

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy";
        let lastVisitDate = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: lastVisit[indexPath.row]))
        if lastVisitDate != "12-31-69" {
            cell.lastVisitLabel.text = lastVisitDate ;
        } else {
            cell.lastVisitLabel.text = "Never"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fieldInfo = "Do you want to mark field " + (self.keys[indexPath.row]) + " as visited";
        
        let fieldInformation = UIAlertController(title: "Field Visited", message: fieldInfo, preferredStyle: UIAlertControllerStyle.Alert)
        
        fieldInformation.addAction(UIAlertAction(title: "Mark as Visited", style: .Default, handler: { (action: UIAlertAction!) in
            self.lastVisit[indexPath.row] = NSDate().timeIntervalSince1970;

            self.handleRefresh();
        }))
        
        fieldInformation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        

        
        presentViewController(fieldInformation, animated: true, completion: nil)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func saveVisits(){
        
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let visitsPath = rootPath.stringByAppendingString("/visits.plist")
        
        let lastVisitDictionary = NSMutableDictionary()

        for visits in 0 ... lastVisit.count -  1{

            lastVisitDictionary.addEntriesFromDictionary([keys[visits] : lastVisit[visits]])
            
        }
        
        lastVisitDictionary.writeToFile(visitsPath, atomically: true)

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
