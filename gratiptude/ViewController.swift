//
//  ViewController.swift
//  gratiptude
//
//  Created by Angela Yu on 8/3/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitView: UIView!
    @IBOutlet weak var splitSlider: UISlider!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var venmoSendButton: UIButton!
    @IBOutlet weak var venmoRequestButton: UIButton!

    
    let imgPicker = UIImagePickerController()
    let splitAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight) ]
    var splitNumber = 1 as Int
    var splitAmountString = "0.00" as String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "myTip")
        defaults.synchronize()
        tipControl.selectedSegmentIndex = defaults.object(forKey: "myTip") as! Int
        billField.becomeFirstResponder()
        imgPicker.delegate = self
        splitSlider.isContinuous = false
        splitSlider.value = Float(splitNumber)
        venmoRequestButton.layer.borderWidth = 1
        venmoRequestButton.layer.borderColor = UIColor.darkGray.cgColor
        venmoSendButton.layer.borderWidth = 1
        venmoSendButton.layer.borderColor = UIColor.darkGray.cgColor
        
        print("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        let tipIndex = defaults.object(forKey: "myTip") as! Int
        tipControl.selectedSegmentIndex = tipIndex
        calculateTip(sender: view)
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
        if splitView.isHidden {
            splitView.isHidden = false
        }
        calculateSplit(splitSlider)
    }
    
    @IBAction func setValue(_ sender: UISlider) {
        sender.setValue(Float(lroundf(splitSlider.value)), animated: true)
        splitNumber = Int(splitSlider.value)
        calculateSplit(sender)
    }
    
    @IBAction func calculateSplit(_ sender: UISlider) {
        let bill = Float(billField.text!) ?? 0
        let tax = Float(taxField.text!) ?? 0
        let tipPercentages = [Float(0.15), Float(0.18), Float(0.2), Float(0.25)]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tax + tip
        let splitAmount = total / Float(splitNumber)
        let splitLabelString = NSMutableAttributedString(string: "\(splitNumber)x  ", attributes: splitAttribute)
        splitAmountString = String(format: "%.2f", splitAmount)
        splitLabelString.append(NSAttributedString(string: "$"))
        splitLabelString.append(NSAttributedString(string: splitAmountString))
        
        splitLabel.attributedText = splitLabelString
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
    
    @IBAction func venmoSend(_ sender: Any) {
        let urlstring = "venmo://paycharge?txn=pay&amount=\(splitAmountString)"
        
        open(scheme: urlstring)
    }
    
    @IBAction func venmoRequest(_ sender: Any) {
        let urlstring = "venmo://paycharge?txn=charge&amount=\(splitAmountString)"
        
        open(scheme: urlstring)
    }

}

