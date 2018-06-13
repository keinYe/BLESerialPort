//
//  Logger.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/4/30.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

final class Logger {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func info(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .i, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func error(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .e, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func debug(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .d, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func varbose(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .v, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func warning(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .w, fileName: fileName, line: line, funcName: funcName)
    }
    
    class func severe(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        log(message: message, event: .s, fileName: fileName, line: line, funcName: funcName)
    }
    
    
    private class func log(message: String,
                           event: LogEvent,
                           fileName: String = #file,
                           line: Int = #line,
                           funcName: String = #function) {
        #if DEBUG
            print("\(dateFormatter.string(from: Date())) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(funcName) -> \(message)")
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
}

