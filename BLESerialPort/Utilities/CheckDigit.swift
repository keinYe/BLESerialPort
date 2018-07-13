//
//  CheckDigit.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/6.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

func CheckSum(_ data:[UInt8]) -> UInt8 {
    var sum = 0
    for num in data {
        sum = sum + Int(num)
    }
    return UInt8(sum % 0x100)
}
