//
//  FirstViewController.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/19/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit

protocol UserInfoTableViewDelegate {
    func delegateMethod(childViewController:HomeViewController, userInfo:AnyObject)
}


class HomeViewController: UIViewController {

    var accessToken = "";
    var email = "";
    var userInfo : AnyObject = "";
    
    var delegate: UserInfoTableViewDelegate?;
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let settingsPath = rootPath.stringByAppendingString("/settings.plist")
        let settingsDictionary = NSMutableDictionary(contentsOfFile: settingsPath)!
        settingsDictionary["token"] = "";
        settingsDictionary["email"] = "";
        if(!settingsDictionary.writeToFile(settingsPath, atomically: true)){
            print("ERROR LOGGING OUT");
        }
        
        performSegueWithIdentifier("logoutSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UserInfoTableViewController();
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let settingsPath = rootPath.stringByAppendingString("/settings.plist")
        let settingsDictionary = NSMutableDictionary(contentsOfFile: settingsPath)!
        accessToken = settingsDictionary["token"]! as! String;
        email = settingsDictionary["email"]! as! String;
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

