//
//  DisplaySetting.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/6.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct DisplaySetting {
    var inputAsciiMode:Bool {
        get {
            return UserDefaults.DisplaySetting.bool(forKey: .inputASCII)
        }
    }
    
    var outputAsciiMode:Bool {
        get {
            return UserDefaults.DisplaySetting.bool(forKey: .outputASCII)
        }
    }
    
    var displayTime:Bool {
        get {
            return UserDefaults.DisplaySetting.bool(forKey: .displayTime)
        }
    }
    
    var displayTxRx:Bool {
        get {
            return UserDefaults.DisplaySetting.bool(forKey: .displayTxRx)
        }
    }
    
    var displaySend:Bool {
        get {
            return UserDefaults.DisplaySetting.bool(forKey: .displaySend)
        }
    }
    
}
