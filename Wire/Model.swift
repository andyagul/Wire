//
//  Model.swift
//  Wire
//
//  Created by Chen Weiru on 20/03/2018.
//  Copyright © 2018 ChenWeiru. All rights reserved.
//

import Foundation

struct Model {
    
    // MARK: Init Func
    init(electricityInfo:String, wireArea:Double, distance:Double, maxChargingCurrent:Double, resistivity:Double, powerFactor:Double ) {
        self.electricityInfo = electricityInfo
        self.wireArea = wireArea
        self.distance = distance
        self.maxChargingCurrent = maxChargingCurrent
        self.resistivity = resistivity
        self.powerFactor = powerFactor
    }
    
    // MARK: Lets
    
    let CopperCoefficientOfResistance = 0.0225
    let electricityInfoDic:[String:(phase:Double, voltage:Double)] = ["singlePhase":(2, 220),
                                                                      "threePhase":(1, 380)]
    // MARK: Vars

    var maxChargingCurrent:Double
    var distance:Double
    var wireArea:Double
    var electricityInfo:String
    var powerFactor:Double
    var resistivity:Double
    var dropVoltage:Double?
    private var dropVoltagePercentage:String?
    
    //MARK: Calculate func
    mutating func voltageDrop(electricityInfo:String, wireArea:Double, distance:Double, maxChargingCurrent:Double, resistivity:Double, powerFactor:Double )->Double{
         dropVoltage = electricityInfoDic[electricityInfo]!.phase *
            ( CopperCoefficientOfResistance * distance / wireArea * powerFactor +
                resistivity * distance * sqrt(1 - powerFactor * powerFactor)) * maxChargingCurrent
        return dropVoltage!
    }
    
    mutating func isSave(dropVoltage:Double)->Bool{
        return dropVoltage / electricityInfoDic[electricityInfo]!.voltage * 100 <= 5 ? true : false
    }
    

    
    
}
