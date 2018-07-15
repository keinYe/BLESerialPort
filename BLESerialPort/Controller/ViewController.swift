//
//  ViewController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/4/25.
//  Copyright © 2018年 keinYe. All rights reserved.
//
import Cocoa
import CoreBluetooth


class ViewController: NSViewController {
    
    private var peripheralManager: BLEPeripheral?
    

    @IBOutlet var outputTextView: NSTextView!
    @IBOutlet var inputTextView: NSTextView!
    
    var lineColor = [String : NSColor]()
    var inputText = InputText()
    var trigger = Trigger()
    var cycle = Cycle()
    var displaySetting = DisplaySetting()
    
    var cycleTimer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inputTextView.delegate = self
        inputTextView.lnv_setUpLineNumberView()
        outputTextView.lnv_setUpLineNumberView()
        inputTextView.string = inputText.str
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        Logger.info("DidAppear")
        peripheralManager = BLEPeripheral()
        peripheralManager?.registerReciveData(call: {uuid, data in
            var reciveString = ""
            if self.displaySetting.outputAsciiMode {
                for char in data {
                    reciveString.append(Character(UnicodeScalar(char)))
                }
            } else {
                reciveString = hexToString(hex: data)
            }
            let reciveDataString = "[\(getNowTime())] " + "Rx: " +  reciveString + "\n"
            self.outputTextView.appendColorString(str: reciveDataString, color: NSColor.blue)
            self.outputTextView.scrollRangeToVisible(NSRange.init(location: self.outputTextView.string.count, length: 1))
            
            guard self.trigger.enable else{
                return
            }
            if let inputLine = self.inputText.getLineNumber(form: hexToString(hex: data)) {
                let _ = Timer.scheduledTimer(timeInterval: self.trigger.delay, target: self, selector: #selector(self.delaySendLine), userInfo: inputLine, repeats: false)
            }
        })
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func bleStartButtonClick(_ sender: NSButton) {
        guard let peripheral = peripheralManager else {
            sender.state = NSControl.StateValue.off
            return
        }
        switch sender.state {
        case NSControl.StateValue.off:
            peripheral.stopAdvertising()
        case NSControl.StateValue.on:
            if peripheral.state == CBManagerState.poweredOn {
                peripheral.publishService()
            } else {
                sender.state = NSControl.StateValue.off
                // 此处需设置提示窗口提示用户开启设备蓝牙
                openAlertPanel(infoTest: "蓝牙未开启！请开启蓝牙")
            }

        default: break
        }
    }
    
    @IBAction func checkButtonClick(_ sender: NSButton) {
        let (string, range) = inputTextView.forSelect()
        guard let str = string else {
            return
        }
        guard !self.displaySetting.inputAsciiMode else {
            openAlertPanel(infoTest: "当前为 ACSII 发送模式！")
            return
        }
        guard checkString(str: str) else {
            openAlertPanel(infoTest: "所选数据不是有效的 hex 数据！")
            return
        }
        var offset = range!.location + range!.length
        let sum = CheckSum(stringToHexArray(str: str))
        if str[str.characters.index(before: str.endIndex)] == " " {
            offset -= 1
        }
        inputTextView.insertString(subString: String(format: " %02X", sum), offsetBy: offset)
    }
    
    @objc private func delaySendLine(timer:Timer) {
        guard let line = timer.userInfo as? Int else {
            return
        }
        if let outputLine = self.trigger.getSendLine(form: "\(line + 1)") {
            if let outputString = self.inputTextView.stringForLineNumber(lineNumber: outputLine) {
                if !self.displaySetting.inputAsciiMode && !checkString(str: outputString) {
                    openAlertPanel(infoTest: "行\(line + 1) 不是有效的 hex 数据！")
                    return
                }
                self.sendData(send: outputString)
            }
        }
    }
    
    @objc private func cycleSendLine(time: Timer) {
        guard cycle.enable else {
            time.invalidate()
            return
        }
        var sendString:String?
        if cycle.enableLine {
            if cycle.enableCurrentLine {
                sendString = self.inputTextView.stringForSelectLine()
            } else {
                sendString = self.inputTextView.stringForLineNumber(lineNumber: cycle.setLine)
            }
        } else {
            sendString = self.inputTextView.stringForLineNumber(lineNumber: cycle.rangeCurrentLine)
            cycle.rangeCurrentLineIncrease()
        }
        if let send = sendString {
            if !self.displaySetting.inputAsciiMode && !checkString(str: send) {
                openAlertPanel(infoTest: "行\(self.inputText.getLineNumber(form: send)! + 1) 不是有效的 hex 数据！")
                return
            }
            sendData(send: send)
            if cycle.enable {
                cycleTimer = Timer.scheduledTimer(timeInterval: self.cycle.delay, target: self, selector: #selector(self.cycleSendLine), userInfo: nil, repeats: false)
            } else {
                cycleTimer = nil
            }
        }
    }
}

extension ViewController {
    @IBAction func sendMenuItemSelected(_ sender: Any) {
        guard let selectString = self.inputTextView.stringForSelectLine() else {
            openAlertPanel(infoTest: "请选择发送行")
            return
        }
        
        if !self.displaySetting.inputAsciiMode && !checkString(str: selectString) {
            openAlertPanel(infoTest: "当前选择行数据错误")
            return
        }
        sendData(send: selectString)
        if cycle.enable && cycleTimer == nil {
            cycleTimer = Timer.scheduledTimer(timeInterval: self.cycle.delay, target: self, selector: #selector(self.cycleSendLine), userInfo: nil, repeats: false)
        } else if cycle.enable == false {
            cycleTimer = nil
        }
    }
    
    @IBAction func clearScreenClick(_ sender: Any) {
        self.outputTextView.clearDisplay()
    }
    
    func openAlertPanel(infoTest: String) {
        let alert = NSAlert()

        alert.addButton(withTitle: "Cancel")
        alert.messageText = "错误"
        alert.informativeText = infoTest
        alert.alertStyle = NSAlert.Style.critical
        alert.runModal()
    }
    
    func sendData(send: String) {
        var output = ""
        if self.displaySetting.inputAsciiMode {
            if self.displaySetting.outputAsciiMode {
                output = send
            } else {
                output = hexToString(hex: Array(send.utf8))
            }
        } else {
            if self.displaySetting.outputAsciiMode {
                for char in stringToHexArray(str: send) {
                    output.append(Character(UnicodeScalar(char)))
                }
            } else {
                output = send
            }
        }
        let sendString = "[\(getNowTime())] " + "Tx: " +  output + "\n"
        self.outputTextView.appendColorString(str: sendString, color: NSColor.red)
        self.outputTextView.scrollRangeToVisible(NSRange.init(location: self.outputTextView.string.count, length: 1))
        peripheralManager?.sendData(data: self.displaySetting.inputAsciiMode ? Array(send.utf8) : stringToHexArray(str: send))
    }
}


extension ViewController: NSTextViewDelegate {
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        Logger.info("\(commandSelector)")
        if commandSelector == #selector(insertNewline(_:)) {
            Logger.info("insert new line")
        }
        return false
    }
    
    func textViewDidChangeSelection(_ notification: Notification) {
        // 当前光标所选内容发生改变
        if (inputText.str != inputTextView.string) {
            inputText.str = inputTextView.string
        }
        Logger.info(inputTextView.string)
    }
    
    func textView(_ textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String] {
        Logger.info("\(words)")
        Logger.info("\(charRange)")
        return []
    }
}

