//
//  CycleSend.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/31.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

class CycleData:NSObject, NSCoding{

    
    @objc dynamic var number : String = ""
    @objc dynamic var input : String = ""
    @objc dynamic var output : String = ""
    
    convenience init(number: String, input: String, output: String) {
        self.init()
        self.number = number
        self.input = input
        self.output = output
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(number, forKey: "number")
        aCoder.encode(input, forKey: "input")
        aCoder.encode(output, forKey: "output")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        if let number = aDecoder.decodeObject(forKey: "number") {
            self.number = number as! String
        }
        if let input = aDecoder.decodeObject(forKey: "input") {
            self.input = input as! String
        }
        if let output = aDecoder.decodeObject(forKey: "output") {
            self.output = output as! String
        }
    }
}

struct CycleSend {
    var data:[CycleData] {
        get {
            if let savedValue = UserDefaults().data(forKey: "cycle_send_data") {
                if let value = NSKeyedUnarchiver.unarchiveObject(with: savedValue) {
                    return value as! [CycleData]
                }
                return cread()
            }
            return cread()
        }
        
        set {
            let saveData = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults().set(saveData, forKey: "cycle_send_data")
        }
    }
    
    private func cread() -> [CycleData] {
        var data = [CycleData]()
        
        for i in 1 ... 20 {
            data.append(CycleData.init(number: "\(i)", input: "", output: ""))
        }
        return data
    }
}
