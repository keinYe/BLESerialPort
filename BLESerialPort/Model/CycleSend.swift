//
//  CycleSend.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/31.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct CycleSend {
    var data:[NSMutableDictionary] {
        if let saveValue = UserDefaults.CycleSend.arrary(forKey: .cycleSend) {
            return saveValue as! [NSMutableDictionary]
        }
        return cread()
    }
    
    private func cread() -> [NSMutableDictionary] {
        var dir:[String:String] = ["number":"1", "input": "", "output":""]
        var arrary = [NSMutableDictionary]()
        for number in 1...20 {
            dir["number"] = "\(number)"
            arrary.append(NSMutableDictionary(dictionary: dir))
        }
        UserDefaults.CycleSend.set(value: arrary, forKey: .cycleSend)
        return arrary
    }
    
    func getSendLine(form inputLine: String) -> Int? {
        for tmpData in data {
            Logger.info("\(String(describing: tmpData["input"]))" + "  " + inputLine)
            if "\(String(describing: tmpData["input"]))" == inputLine {
                return Int(String(describing: tmpData["output"]))
            }
        }
        return nil
    }
}
