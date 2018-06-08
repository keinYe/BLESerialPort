//
//  Input.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/8.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct InputText {
    var str : String {
        mutating get {
            let savedValue = UserDefaults.standard.string(forKey: "InputString")
            if let value = savedValue {
                setLineString(value)
                return value
            }
            return ""
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "InputString")
            setLineString(newValue)
        }
    }
    
    fileprivate var lineString = [String : Int]()
    
    mutating func setLineString(_ input:String) {
        guard !input.isEmpty else {
            return
        }
        lineString = [:]
        // 将字符串按换行符拆分为字符串数组，并去除字符串前后的空格
        let splitedArrary = input.components(separatedBy: "\n").map{$0.trimmingCharacters(in: .whitespaces)}
        for (index, value) in splitedArrary.enumerated() {
            lineString[value] = index
        }
    }
    
    func getLineNumber(form input: String) -> Int? {
        // 去除字符串前后的空格
        let str = input.trimmingCharacters(in: .whitespaces)
        if let lineNumber = lineString[str] {
            return lineNumber
        }
        return nil
    }
}
