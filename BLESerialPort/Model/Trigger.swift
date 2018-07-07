//
//  Tigger.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/2.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct Trigger {
    var line:[NSMutableDictionary] {
        if let saveValue = UserDefaults.Trigger.arrary(forKey: .trigger) {
            return saveValue as! [NSMutableDictionary]
        }
        return cread()
    }
    
    var enable:Bool {
        get {
            return UserDefaults.Trigger.bool(forKey: .triggerEnable)
        }
        set {
            UserDefaults.Trigger.set(value: newValue, forKey: .triggerEnable)
        }
    }
    var delay:Double {
        if let saveValue = UserDefaults.Trigger.integer(forKey: .triggerDelay) {
            return Double(saveValue) / 1000
        }
        return 0.01
    }
    
    private func cread() -> [NSMutableDictionary] {
        var dir:[String:String] = ["number":"1", "input": "", "output":""]
        var arrary = [NSMutableDictionary]()
        for number in 1...20 {
            dir["number"] = "\(number)"
            arrary.append(NSMutableDictionary(dictionary: dir))
        }
        UserDefaults.Trigger.set(value: arrary, forKey: .trigger)
        return arrary
    }
    
    func getSendLine(form inputLine: String) -> Int? {
        for tmpData in line {
            guard let input = tmpData["input"] as? String, let output = tmpData["output"] as? String else {
                continue
            }
            if input == inputLine {
                return Int(output)
            }
        }
        return nil
    }
}
