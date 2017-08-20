//
//  ViewController.swift
//  gratiptude
//
//  Created by Angela Yu on 8/3/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
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
        splitView.isHidden = true
        
//        if let tesseract:G8Tesseract = G8Tesseract(language:"eng") {
//            //tesseract.language = "eng+ita";
//            tesseract.delegate = self
//            tesseract.charWhitelist = "0123456789"
//            tesseract.image = UIImage(named: "image_sample.jpg")?.g8_blackAndWhite()
//            tesseract.recognize()
//        
//            NSLog("%@", tesseract.recognizedText)
//        }
        
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
        // let venmoUrl = URL(string: urlstring)
        
        open(scheme: urlstring)
    }
    
    @IBAction func venmoRequest(_ sender: Any) {
        let urlstring = "venmo://paycharge?txn=charge&amount=\(splitAmountString)"
        // let venmoUrl = URL(string: urlstring)
        
        open(scheme: urlstring)
    }
    
//    @IBAction func recognizeImageWithTesseract(_ image: UIImage) {
//        // Animate a progress activity indicator
//        // self.thinkingIndicator.startAnimating()
//        
//        // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
//        // It is assumed that there is a .traineddata file for the language pack
//        // you want Tesseract to use in the "tessdata" folder in the root of the
//        // project AND that the "tessdata" folder is a referenced folder and NOT
//        // a symbolic group in your project
//        let operation = G8RecognitionOperation(language:"eng")
//        
//        // Use the original Tesseract engine mode in performing the recognition
//        // (see G8Constants.h) for other engine mode options
//        operation?.tesseract.engineMode = G8OCREngineMode.tesseractOnly
//        
//        // Let Tesseract automatically segment the page into blocks of text
//        // based on its analysis (see G8Constants.h) for other page segmentation
//        // mode options
//        operation?.tesseract.pageSegmentationMode = G8PageSegmentationMode.autoOnly
//        
//        // Optionally limit the time Tesseract should spend performing the
//        // recognition
//        operation?.tesseract.maximumRecognitionTime = 1.0
//        
//        // Set the delegate for the recognition to be this class
//        // (see `progressImageRecognitionForTesseract` and
//        // `shouldCancelImageRecognitionForTesseract` methods below)
//        operation?.delegate = self
//        
//        // Optionally limit Tesseract's recognition to the following whitelist
//        // and blacklist of characters
//        //operation.tesseract.charWhitelist = @"01234";
//        //operation.tesseract.charBlacklist = @"56789";
//        
//        // Set the image on which Tesseract should perform recognition
//        operation?.tesseract.image = image
//        
//        // Optionally limit the region in the image on which Tesseract should
//        // perform recognition to a rectangle
//        //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
//        
//        // Specify the function block that should be executed when Tesseract
//        // finishes performing recognition on the image
////        operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
////            // Fetch the recognized text
////            NSString *recognizedText = tesseract.recognizedText;
////            
////            NSLog(@"%@", recognizedText);
////            
////            // Remove the animated progress activity indicator
////            [self.activityIndicator stopAnimating];
////            
////            // Spawn an alert with the recognized text
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
////                message:recognizedText
////                delegate:nil
////                cancelButtonTitle:@"OK"
////                otherButtonTitles:nil];
////            [alert show];
////        };
//        
//        // Display the image to be recognized in the view
//        // self.imageToRecognize.image = operation.tesseract.thresholdedImage;
//        
//        // Finally, add the recognition operation to the queue
//        // [self.operationQueue addOperation:operation];
//    }
//    
//    /**
//     *  This function is part of Tesseract's delegate. It will be called
//     *  periodically as the recognition happens so you can observe the progress.
//     *
//     *  @param tesseract The `G8Tesseract` object performing the recognition.
//     */
//    func progressImageRecognition(for tesseract: G8Tesseract!) {
//        NSLog("Recognition progress \(tesseract.progress) %")
//    }
//    
//    /**
//     *  This function is part of Tesseract's delegate. It will be called
//     *  periodically as the recognition happens so you can cancel the recogntion
//     *  prematurely if necessary.
//     *
//     *  @param tesseract The `G8Tesseract` object performing the recognition.
//     *
//     *  @return Whether or not to cancel the recognition.
//     */
//    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
//        return false; // return true if you need to interrupt tesseract before it finishes
//    }
    
    @IBAction func openCamera(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imgPicker.sourceType = UIImagePickerControllerSourceType.camera
            imgPicker.allowsEditing = false
            imgPicker.cameraCaptureMode = .photo
            imgPicker.modalPresentationStyle = .fullScreen
            present(imgPicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
//    @IBAction func recognizeSampleImage(_ sender: Any) {
//        self.recognizeImageWithTesseract((UIImage(named: "image_sample.jpg")?.g8_blackAndWhite())!)
//    }
//    
//    //MARK: - Delegates
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject])
//    {
//        let image1 = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        picker.dismiss(animated: true, completion: nil)
//        self.recognizeImageWithTesseract(image1)
//    }
//   
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        
//    }
}

