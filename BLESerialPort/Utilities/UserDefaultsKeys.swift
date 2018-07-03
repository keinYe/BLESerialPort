//
//  UserDefaultsKeys.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/30.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation


extension UserDefaults {
    struct General:UserDefaultsSettable {
        enum defaultKeys:String {
            case serviceUUID
            case writeUUID
            case readUUID
            case notifyUUID
        }
    }
    struct Trigger:UserDefaultsSettable {
        enum defaultKeys:String {
            case trigger
            case triggerDelay
            case triggerEnable
        }
    }
}


protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
    
    static func set(value: Any?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func arrary(forKey key: defaultKeys) -> [Any]? {
        let aKey = key.rawValue
        return UserDefaults.standard.array(forKey: aKey)
    }
    
    static func object(forKey key: defaultKeys) -> Any? {
        let aKey = key.rawValue
        return UserDefaults.standard.object(forKey: aKey)
    }
    
    static func set(value: Int?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func integer(forKey key: defaultKeys) -> Int? {
        let aKey = key.rawValue
        return UserDefaults.standard.integer(forKey: aKey)
    }
    
    static func set(value: Bool, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func bool(forKey key: defaultKeys) -> Bool {
        let aKey = key.rawValue
        return UserDefaults.standard.bool(forKey: aKey)
    }
}
