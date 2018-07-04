//
//  Cycle.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/4.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct Cycle {
    var enableLine:Bool {
        get {
            return UserDefaults.Cycle.bool(forKey: .enableLine)
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .enableLine)
        }
    }
    
    var enableCurrentLine:Bool {
        get {
            return UserDefaults.Cycle.bool(forKey: .enableCurrentLine)
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .enableCurrentLine)
        }
    }
    
    var enable:Bool {
        get {
            return UserDefaults.Cycle.bool(forKey: .cycleEnable)
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .cycleEnable)
        }
    }
    var setLine:Int {
        get {
            if let save = UserDefaults.Cycle.integer(forKey: .setLine) {
                return save
            }
            UserDefaults.Cycle.set(value: 1, forKey: .setLine)
            return 1
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .setLine)
        }
    }
    var rangeStartLine:Int {
        get {
            if let save = UserDefaults.Cycle.integer(forKey: .rangeStartLine) {
                return save
            }
            UserDefaults.Cycle.set(value: 1, forKey: .rangeStartLine)
            return 1
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .rangeStartLine)
        }
    }
    var rangeEndLine:Int {
        get {
            if let save = UserDefaults.Cycle.integer(forKey: .rangeEndLine) {
                return save
            }
            UserDefaults.Cycle.set(value: 1, forKey: .rangeEndLine)
            return 1
        }
        set {
            UserDefaults.Cycle.set(value: newValue, forKey: .rangeEndLine)
        }
    }
    
    var delay:Double {
        if let saveValue = UserDefaults.Cycle.integer(forKey: .cycleDelay) {
            return Double(saveValue) / 1000
        }
        UserDefaults.Cycle.set(value: 10, forKey: .cycleDelay)
        return 0.01
    }
    
}
