//
//  ViewController.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    let animationDuration:TimeInterval = 0.4
    let offSet:CGFloat = -140
    
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
        for textField in textFieldColletion{
            textField.keyboardType = .decimalPad
        }
    }
    
 
    
    private var textFieldObserver:NSObjectProtocol?
    
    
    
    var maxChargingCurrent:Double = 16
    var distance:Double = 25
    var wireArea:String = "1.5mm²"
    var electricityInfo:String = "singlePhase"
    
    lazy var model = Model(electricityInfo: self.electricityInfo, wireArea: self.wireArea, distance: self.distance, maxChargingCurrent: self.maxChargingCurrent)

    @IBOutlet var textFieldColletion: [TextField]!
    
    @IBOutlet weak var distanceTextField: TextField!
    
    @IBAction func testButton(_ sender: UIButton) {
        print(model.voltageDrop)
        print(model.isSave)
        print(model.dropPercentage)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: animationDuration) {
              self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
      
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let observer = self.textFieldObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

