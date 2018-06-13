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
            let savedValue = UserDefaults.standard.string(forKey: "preferences-service-uuid")
            if savedValue != nil && !(savedValue?.isEmpty)! {
                return savedValue!
            }
            return "FFF0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferences-service-uuid")
        }
    }
    
    var readUUID: String {
        get {
            let savedVale = UserDefaults.standard.string(forKey: "preferences-read-uuid")
            if savedVale != nil && !(savedVale?.isEmpty)! {
                return savedVale!
            }
            return "FFF1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferences-read-uuid")
        }
    }
    
    var writeUUID: String {
        get {
            let savedVale = UserDefaults.standard.string(forKey: "preferences-write-uuid")
            if savedVale != nil && !(savedVale?.isEmpty)! {
                return savedVale!
            }
            return "FFF2"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferences-write-uuid")
        }
    }
    
    var notifyUUID: String {
        get {
            let savedVale = UserDefaults.standard.string(forKey: "preferences-notify-uuid")
            if savedVale != nil && !(savedVale?.isEmpty)! {
                return savedVale!
            }
            return "FFF3"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferences-notify-uuid")
        }
    }
}
