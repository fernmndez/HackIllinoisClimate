//
//  ViewController.swift
//  HackIllinoisClimate
//
//  Created by Fernando Mendez on 2/19/16.
//  Copyright © 2016 Fernando Mendez. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    internal var settings: NSMutableDictionary = NSMutableDictionary();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("will appear")
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
