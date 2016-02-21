//
//  LoginViewController.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/19/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit
import LoginWithClimate

class LoginViewController: UIViewController, LoginWithClimateDelegate {

    var settingsDictionary : NSMutableDictionary = NSMutableDictionary();
    
    let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
    var settingsPath: String = "";
    var visitsPath: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePlistForUse();
        readSettings();
        
        let loginViewController = LoginWithClimateButton(clientId: "dphoqs7n770o4u", clientSecret: "9inonrnhe4jthbo43jdhlpi853")
        loginViewController.delegate = self
        
        view.addSubview(loginViewController.view)
        
        loginViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["view":loginViewController.view]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view]-500-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":loginViewController.view]))
        
        self.addChildViewController(loginViewController)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readSettings(){
        
        settingsDictionary = NSMutableDictionary(contentsOfFile: settingsPath)!
        if(settingsDictionary["token"]! as! String != ""){
            dispatch_async(dispatch_get_main_queue(), {
                print("token exists, launching main view \n token : ", self.settingsDictionary["token"]!);
                self.performSegueWithIdentifier("LoggedInSegue", sender: nil)
            })
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue");
        if(segue.identifier == "LoggedInSegue"){
            print("logged in segue activated");
            if let destinationViewController = segue.destinationViewController as? HomeTabBarViewController {
                destinationViewController.settings = settingsDictionary;
            }
        }
    }
    
    
    func didLoginWithClimate(session: Session) {
        print("Scope: ", session.userInfo);
        print("Expires : ", session.expiresIn);
        print(session.accessToken);
        
        
        settingsDictionary["token"] = session.accessToken!;
        settingsDictionary["email"] = session.userInfo.email;
        
        settingsDictionary.writeToFile(settingsPath, atomically: true)
        
        readSettings()
    }

    
    func preparePlistForUse(){
        

        settingsPath = rootPath.stringByAppendingString("/settings.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(settingsPath){
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("settings", ofType: "plist") as String!
            
            do {
                try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: settingsPath)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
        }

        visitsPath = rootPath.stringByAppendingString("/visits.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(visitsPath){
            let plistPathInBundle = NSBundle.mainBundle().pathForResource("visits", ofType: "plist") as String!
            
            do {
                try NSFileManager.defaultManager().copyItemAtPath(plistPathInBundle, toPath: visitsPath)
            }catch{
                print("Error occurred while copying file to document \(error)")
            }
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
