//
//  ViewController.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let animationDuration:TimeInterval = 0.25
    let offSet:CGFloat = -170.00
    let textFieldCornerRadius:CGFloat = 3.00
    
    var defaultTextFieldCornerRadius:CGFloat?
    var defaultTextFieldBorderWidth:CGFloat?
    var defaultTextFieldBorderColor:CGColor?
    
    
    private var textFieldObserver:NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textFieldObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.UIKeyboardWillShow,
            object: nil,
            queue: OperationQueue.main,
            using: { notification in
                self.view.frame = CGRect(x: 0, y: self.offSet , width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for textField in textFieldCollection{
            textField.keyboardType = .decimalPad
        }
    }
    
    override func viewDidLoad() {
        defaultTextFieldBorderColor = distanceTextField.layer.borderColor
        defaultTextFieldBorderWidth = distanceTextField.layer.borderWidth
        defaultTextFieldCornerRadius = distanceTextField.layer.cornerRadius
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let observer = self.textFieldObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: animationDuration) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        self.view.endEditing(true)
    }
    
    lazy var model = Model(electricityInfo: self.electricityInfo!, wireArea: self.wireArea!, distance: self.distance!, maxChargingCurrent: self.maxChargingCurrent!, resistivity: self.resistivity!, powerFactor: self.powerFactor!)
    
    
    
    @IBOutlet weak var voltageDropLabel: UILabel!
    
    @IBOutlet var textFieldCollection: [TextField]!
    @IBOutlet weak var distanceTextField: TextField!
    @IBOutlet weak var powerFactorTextField: TextField!
    @IBOutlet weak var resistivityTextField: TextField!
    @IBOutlet weak var maxCurrentTextField: TextField!
    @IBOutlet weak var electricityInfoSegment: UISegmentedControl!
    @IBOutlet weak var wireAreaSegment: UISegmentedControl!
    
    var maxChargingCurrent:Double?
    var distance:Double?
    var wireArea:Double?
    var electricityInfo:String?
    var powerFactor:Double?
    var resistivity:Double?
    
    

   
    
    
    
    @IBAction func calculateButton(_ sender: UIButton) {
       
        for textField in textFieldCollection{
            textField.layer.borderColor = defaultTextFieldBorderColor
            textField.layer.borderWidth = defaultTextFieldBorderWidth!
            textField.layer.cornerRadius = defaultTextFieldCornerRadius!
        }
        
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        self.view.endEditing(true)
        guard self.isValidNumber(textField: distanceTextField) else {
            showAlter(textField: distanceTextField)
            return
        }
        guard self.isValidNumber(textField: maxCurrentTextField) else{
            showAlter(textField: maxCurrentTextField)
            return
        }
        guard self.isValidNumber(textField: resistivityTextField) else{
            showAlter(textField: resistivityTextField)
            return
        }
        guard self.isValidNumber(textField: powerFactorTextField) else{
            showAlter(textField: powerFactorTextField)
            return
        }
        
        powerFactor = Double(powerFactorTextField.text!)!
        guard powerFactor! > 0 && powerFactor! <= 1 else{
            showAlter(textField: powerFactorTextField)
            return
        }
        
        resistivity = Double(resistivityTextField.text!)!
        maxChargingCurrent = Double(maxCurrentTextField.text!)!
        distance = Double(distanceTextField.text!)!
        
        wireArea = Double(wireAreaSegment.titleForSegment(at: wireAreaSegment.selectedSegmentIndex)!)!
        electricityInfo = electricityInfoSegment.selectedSegmentIndex == 0 ? "singlePhase" : "threePhase"
        
        
        let volDrop = model.voltageDrop(electricityInfo: electricityInfo!, wireArea: wireArea!, distance: distance!, maxChargingCurrent: maxChargingCurrent!, resistivity: resistivity!, powerFactor: powerFactor!)
        
        voltageDropLabel.text = String(format:"%.2f", volDrop )
        
        
    }
    
    
    
    
    
    private func isValidNumber(textField:TextField)->Bool{
        guard let text = textField.text else {
            return false
        }
        guard let _ = Double(text) else {
            return false
        }
        
        
        return true
    }
    
    func showAlter(textField:TextField){
        let alert = UIAlertController(title: "无效参数",
                                      message: textField.text,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler:{ _ in
                                        textField.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                                        textField.layer.borderWidth = 1.0
                                        textField.layer.cornerRadius = self.textFieldCornerRadius
        
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
}

