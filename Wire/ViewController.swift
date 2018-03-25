//
//  ViewController.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let animatiingDuration:TimeInterval = 0.25
    let textFieldCornerRadius:CGFloat = 3.00
    let moreOffSet:CGFloat = 30
    
    var defaultTextFieldCornerRadius:CGFloat?
    var defaultTextFieldBorderWidth:CGFloat?
    var defaultTextFieldBorderColor:CGColor?
    var keyboardHeight:CGFloat?
    
    var editingTextFlied:TextField?
    
    
    private var textFieldObserver:NSObjectProtocol?
    private var keyboardOberver:NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textFieldObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.UIKeyboardWillShow,
            object: nil,
            queue: OperationQueue.main,
            using: { notification in
               
                
                let userInfo = notification.userInfo as NSDictionary!
                let aValue = userInfo?.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
                let keyboardRect = aValue.cgRectValue
                self.keyboardHeight = keyboardRect.size.height
          
           
                
                for textField in self.textFieldCollection{
                    if textField.isEditing{
                        self.editingTextFlied = textField
                    }
                }
                
              
                
                //TODO: - offset
                let  textFildRect = self.editingTextFlied?.superview?.convert((self.editingTextFlied?.frame)!, to: self.view)
                let texfieldDicarOriginY = UIScreen.main.bounds.size.height -  (textFildRect?.origin.y)!
                
                let offSet:CGFloat = self.keyboardHeight! + (self.editingTextFlied?.frame.height)! < texfieldDicarOriginY ? 0 : 
                    self.keyboardHeight! - texfieldDicarOriginY + (self.editingTextFlied?.frame.size.height)! + self.moreOffSet
            
                    self.view.frame = CGRect(x: 0, y: -offSet, width: self.view.frame.size.width, height: self.view.frame.size.height)
       
        })
        
     
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for textField in textFieldCollection{
            textField.keyboardType = .decimalPad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        UIView.animate(withDuration: animatiingDuration) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.endEditing(true)
        }
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
    @IBOutlet weak var resultLable: UILabel!
    
    var maxChargingCurrent:Double?
    var distance:Double?
    var wireArea:Double?
    var electricityInfo:String?
    var powerFactor:Double?
    var resistivity:Double?
    var dropVoltage:Double?
    var result:Bool?
    
    

   
    
    
    
    @IBAction func calculateButton(_ sender: UIButton) {
       
        UIView.animate(withDuration: animatiingDuration) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.endEditing(true)


        }
        
        for textField in textFieldCollection{
            textField.layer.borderColor = defaultTextFieldBorderColor
            textField.layer.borderWidth = defaultTextFieldBorderWidth!
            textField.layer.cornerRadius = defaultTextFieldCornerRadius!
        }
        
        
        let asyncTime = DispatchTime.now() + animatiingDuration
        
        guard self.isValidNumber(textField: distanceTextField) else {
            DispatchQueue.main.asyncAfter(deadline: asyncTime){
                self.showAlter(textField: self.distanceTextField)
            }
            return
        }
        
        guard self.isValidNumber(textField: maxCurrentTextField) else{
            DispatchQueue.main.asyncAfter(deadline: asyncTime,
                                          execute:{ self.showAlter(textField: self.maxCurrentTextField) })
            return
        }
        
        guard self.isValidNumber(textField: powerFactorTextField) else{
            DispatchQueue.main.asyncAfter(deadline: asyncTime,
                                          execute: { self.showAlter(textField: self.powerFactorTextField)})
            return
        }
        
        powerFactor = Double(powerFactorTextField.text!)!
        guard powerFactor! > 0 && powerFactor! <= 1 else{
            DispatchQueue.main.asyncAfter(deadline: asyncTime,
                                          execute: { self.showAlter(textField: self.powerFactorTextField)
            })
            return
        }
        
        guard self.isValidNumber(textField: resistivityTextField) else{
            DispatchQueue.main.asyncAfter(deadline: asyncTime,
                                          execute: { self.showAlter(textField: self.resistivityTextField) })
            return
        }
        
        resistivity = Double(resistivityTextField.text!)!
        maxChargingCurrent = Double(maxCurrentTextField.text!)!
        distance = Double(distanceTextField.text!)!
        
        wireArea = Double(wireAreaSegment.titleForSegment(at: wireAreaSegment.selectedSegmentIndex)!)!
        electricityInfo = electricityInfoSegment.selectedSegmentIndex == 0 ? "singlePhase" : "threePhase"
        
        
        dropVoltage = model.voltageDrop(electricityInfo: electricityInfo!, wireArea: wireArea!, distance: distance!, maxChargingCurrent: maxChargingCurrent!, resistivity: resistivity!, powerFactor: powerFactor!)
        voltageDropLabel.text = String(format:"%.2f", dropVoltage! )
        
        result = model.isSave(dropVoltage: dropVoltage!)
        resultLable.text = result! ? "合格" : "不合格"

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

