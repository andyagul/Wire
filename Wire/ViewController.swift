//
//  ViewController.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var maxChargingCurrent:Double = 16
    var distance:Double = 25
    var wireArea:String = "1.5mm²"
    var electricityInfo:String = "singlePhase"
    
    lazy var model = Model(electricityInfo: self.electricityInfo, wireArea: self.wireArea, distance: self.distance, maxChargingCurrent: self.maxChargingCurrent)
    
    @IBAction func testButton(_ sender: UIButton) {
        print(model.voltageDrop)
        print(model.isSave)
        print(model.dropPercentage)
        
    }
    
}

