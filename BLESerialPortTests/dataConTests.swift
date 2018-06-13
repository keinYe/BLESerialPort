//
//  dataConTests.swift
//  BLESerialPortTests
//
//  Created by keinYe on 2018/6/12.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import XCTest
@testable import BLESerialPort

class dataConTests: XCTestCase {
    
    func testDataCheckString() {
        XCTAssertTrue(checkString(str: "FF AA BB CC DD EE FF"), "checkString Test true Faile")
        XCTAssertFalse(checkString(str: "HA 00 01"), "checkString Test false Faile")
        XCTAssertFalse(checkString(str: "AAF 00 01"), "checkString Test false Faile")
        XCTAssertFalse(checkString(str: "AA 00 00 0101"), "checkString Test false Faile")
    }
    func testStringToHexArrary() {
        XCTAssertEqual(stringToHexArray(str: "FF AA BB CC DD EE FF"),  [0xFF, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF])
        XCTAssertEqual(stringToHexArray(str: "AA 00 00 0101"), [UInt8]())
        XCTAssertEqual(stringToHexArray(str: "AAF 00 01"), [UInt8]())
        XCTAssertEqual(stringToHexArray(str: "HA 00 01"), [UInt8]())
    }
    
    func testHexToString() {
        XCTAssertEqual(hexToString(hex: [0xFF, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF]), "FF AA BB CC DD EE FF ")
        XCTAssertEqual(hexToString(hex: [0x01, 0x23, 0x45, 0x67, 0x89]), "01 23 45 67 89 ")
    }

}
