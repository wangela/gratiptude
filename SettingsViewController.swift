//
//  SettingsViewController.swift
//  gratiptude
//
//  Created by Angela Yu on 8/4/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let defaults = UserDefaults.standard
        let tipIndex = defaults.object(forKey: "myTip") as! Int
        defaultTipSelector.selectedSegmentIndex = tipIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func setDefaultTip(_ sender: Any) {
        
        let defaults = UserDefaults.standard // Swift 3 syntax, previously NSUserDefaults.standardUserDefaults()
        defaults.set(defaultTipSelector.selectedSegmentIndex, forKey: "myTip")
        defaults.synchronize()
    }
}
