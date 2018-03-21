//
//  Model.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import Foundation

struct Model {
    
    init(electricityInfo:String, wireArea:String, distance:Double, maxChargingCurrent:Double ) {
        self.electricityInfo = electricityInfo
        self.wireArea = wireArea
        self.distance = distance
        self.maxChargingCurrent = maxChargingCurrent
    }
    
    let DefaulPowerFactor = 0.80
    let CopperCoefficientOfResistance = 0.0225
    let Resistivity = 0.00008
    let electricityInfoDic:[String:(phase:Double, voltage:Double)] = ["singlePhase":(2, 220),
                                                                      "threePhase":(1, 380)]
    let wireAreaDic:Dictionary<String, Double> = ["1mm²":1,
                                                  "1.5mm²":1.5,
                                                  "2.5mm²":2.5,
                                                  "4mm²":4,
                                                  "6mm²":6,
                                                  "10mm²":10]
    var maxChargingCurrent:Double
    var distance:Double
    var wireArea:String
    var electricityInfo:String
    var powerFactor:Double{
        set{
            self.powerFactor = newValue
        }
        get{
            return DefaulPowerFactor
        }
    }
    
    var voltageDrop:Double{
        return electricityInfoDic[electricityInfo]!.phase *
            ( CopperCoefficientOfResistance * distance / wireAreaDic[wireArea]! * powerFactor +
                Resistivity * distance * sqrt(1 - powerFactor * powerFactor)) * maxChargingCurrent
        
    }
    
    var dropPercentage:String{
        return String(self.voltageDrop / electricityInfoDic[electricityInfo]!.voltage * 100) + "%"
    }
    
    var isSave:Bool {
        if (self.voltageDrop / electricityInfoDic[electricityInfo]!.voltage * 100) <= 3{
            return true
        }else{
            return false
        }
    }
    
    
}
