//
//  UserInfoTableViewController.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/19/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit


class UserInfoTableViewController: UITableViewController, UserInfoTableViewDelegate {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fieldsLabel: UILabel!
    @IBOutlet weak var acresLabel: UILabel!
    
    var accessToken = "";
    var email = "";
    var userInfo: NSMutableDictionary?;
    var delegate: UserInfoTableViewDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateInformation();
    }
    
    func delegateMethod(childViewController:HomeViewController, userInfo:AnyObject){
        self.userInfo = userInfo as? NSMutableDictionary;
        print(userInfo)
        

    }
    
    func updateInformation(){
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let settingsPath = rootPath.stringByAppendingString("/settings.plist")
        let settingsDictionary = NSMutableDictionary(contentsOfFile: settingsPath)!
        accessToken = settingsDictionary["token"]! as! String;
        
        email = settingsDictionary["email"]! as! String;
        getUserInformation();
        getFieldInformation();
    }
    func getFieldInformation(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://hackillinois.climate.com/api/fields")!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            var numberOfFields = 0;
            var numberOfAcres = 0;
            let jsonObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: [])
            
            for i : [String: AnyObject] in (jsonObject["fields"] as! Array) {
                numberOfAcres += (i["area"]!["q"]! as! Int)
                numberOfFields++; // use ++ instead of += 1 as ++ is a single machine code op, increment
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.fieldsLabel.text = ("Fields : " + numberOfFields.description )
                self.acresLabel.text = ("Acres : " + numberOfAcres.description )
            });
        }           
        task.resume()
        
    }
    
    func getUserInformation(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://hackillinois.climate.com/api/users/details?email=" + email)!)
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            self.userInfo = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSMutableDictionary
            dispatch_async(dispatch_get_main_queue(), {
           
                let name = (self.userInfo!["firstname"] as? String)! + " " + (self.userInfo!["lastname"] as? String)!;

                
                
                self.nameLabel.text = name;
                self.emailLabel.text = (self.userInfo!["email"] as? String);

                
            })
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.section, indexPath.row)
        if(indexPath.section == 2){
            switch(indexPath.row){

            case 0:
                print("opening")
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.sandiegouniontribune.com/news/2016/feb/19/stone-brewing-farming-operations-closed/")!)
                break;
            case 1:
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.weau.com/home/headlines/The-number-of-farms-decrease-as-competition-for-land-rises-369491502.html")!)
                break;
            case 2:
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.lancasterfarming.com/0220-Holistic-Cattle-Grazing-Approach")!)
            case 3:
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.news-leader.com/story/news/education/2016/02/17/msu-leases-downtown-silos-urban-farming-start-up/80524672/")!)

            default:
                break;
                
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
