//
//  ViewController.swift
//  PayMe
//
//  Created by Aaron Markey on 9/21/16.
//  Copyright © 2016 Aaron Markey. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var payRate: UITextField!
    @IBOutlet weak var otRate: UITextField!
    @IBOutlet weak var hoursWorked: UITextField!
    @IBOutlet weak var taxRate: UITextField!
    @IBOutlet weak var other: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var otRateResult: UILabel!
    @IBOutlet weak var otHoursResult: UILabel!
    @IBOutlet weak var grossResult: UILabel!
    @IBOutlet weak var totalTaxesResult: UILabel!
    @IBOutlet weak var netResult: UILabel!
    
    //MARK: Actions
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }

    
    @IBAction func calculateButton(_ sender: UIButton) {
        
        //create VF objects
        let payCF = ValidateField<Float>(field: payRate, fieldDefault: "7.25", message: "Pay rate should be the amount made per hour and at least 0. Ex: 10.75, 21.00", fromView: self, type: Float())
        let otCF = ValidateField<Float>(field: otRate, fieldDefault: "1.5", message: "Overtime rate should be the number hourly pay is raise at and at least 0. Ex: 1.5, 1.75", fromView: self, type: Float())
        let hoursCF = ValidateField<Int>(field: hoursWorked, fieldDefault: "0", message: "Hours Worked should be a whole value and at least 0. Ex: 20, 33", fromView: self, type: Int())
        let taxCF = ValidateField<Float>(field: taxRate, fieldDefault: "12.00", message: "Tax Rate should be some number and at least 0. Ex: 12, 8.25", fromView: self, type: Float())
        let otherCF = ValidateField<Float>(field: other, fieldDefault: "0.00", message: "Other should be some dollar amount and at least 0. Ex: 10.75, 21.00", fromView: self, type: Float())
        
        //some check flag
        var check = true
        check = check ? payCF.check().check : check
        check = check ? otCF.check().check : check
        check = check ? hoursCF.check().check : check
        check = check ? taxCF.check().check : check
        check = check ? otherCF.check().check : check
        
        
        //if check passes, calculate results
        if(check) {
            let results = calculateResults(payCF.check().float, otRate: otCF.check().float, hoursWorked: hoursCF.check().int, taxRate: taxCF.check().float, other: otherCF.check().float)
            
            displayResults(results, otRateResult: otRateResult, otHoursResult: otHoursResult, grossResult: grossResult, totalTaxesResult: totalTaxesResult, netResult: netResult)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otRateResult.text = ""
        otHoursResult.text = ""
        grossResult.text = ""
        totalTaxesResult.text = ""
        netResult.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payRate.addToolbarToKeyboard(view: self.view)
        otRate.addToolbarToKeyboard(view: self.view)
        hoursWorked.addToolbarToKeyboard(view: self.view)
        taxRate.addToolbarToKeyboard(view: self.view)
        other.addToolbarToKeyboard(view: self.view)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: UIResponder functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.touchesBegan(touches, with: event)
    }
}

extension UITextField {
    func addToolbarToKeyboard(view: UIView) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = createColor()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resignKeyboard)),
        ]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    func resignKeyboard() {
        self.resignFirstResponder()
    }
}
