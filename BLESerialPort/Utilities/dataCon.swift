//
//  dataCon.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/21.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

struct Regex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

func checkString(str: String) -> Bool {
    let pattern = "^([0-9a-fA-F]{2}[ ]{1})*([0-9a-fA-F]{2})?$"
    let matcher = Regex(pattern)
    if matcher.match(input: str) {
        return true
    }
    return false
}

func stringToHexArray(str: String) -> [UInt8] {
    guard checkString(str: str) else {
        return [UInt8]()
    }
    let splitedArray = str.characters.split{$0 == " "}.map(String.init)
    let hexArray = splitedArray.map{str in strtoul(str, nil, 16)}.map{data in UInt8(data)}
    return hexArray
}

func hexToString(hex:[UInt8]) -> String {
    return hex.reduce("") {total, data in total + String(format: "%02X ", data)}
}
