//
//  ViewController.swift
//  gratiptude
//
//  Created by Angela Yu on 8/3/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "myTip")
        defaults.synchronize()
        tipControl.selectedSegmentIndex = defaults.object(forKey: "myTip") as! Int
        print("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        let tipIndex = defaults.object(forKey: "myTip") as! Int
        tipControl.selectedSegmentIndex = tipIndex
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let tipPercentages = [0.15, 0.18, 0.2, 0.25]
        
        let bill = Double(billField.text!) ?? 0
        let tax = Double(taxField.text!) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tax + tip
        
        billField.text = String(format: "%.2f", bill)
        taxField.text = String(format: "%.2f", tax)
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

