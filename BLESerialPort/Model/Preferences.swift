//
//  Preferences.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/6.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct Preferencs {
    var serviceUUID: String {
        get {
            let savedValue = UserDefaults.standard.string(forKey: "serviceUUID")
            if savedValue != nil && !(savedValue?.isEmpty)! {
                return savedValue!
            }
            return "FFF0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "serviceUUID")
        }
    }
    
    var characUUID: String {
        get {
            let savedVale = UserDefaults.standard.string(forKey: "characUUID")
            if savedVale != nil && !(savedVale?.isEmpty)! {
                return savedVale!
            }
            return "FFF1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "characUUID")
        }
    }
}
