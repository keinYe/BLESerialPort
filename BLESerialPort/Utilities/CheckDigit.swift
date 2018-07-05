//
//  CheckDigit.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/6.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

func CheckSum(_ data:[UInt8]) -> UInt8 {
    return data.reduce(0, +)
}
