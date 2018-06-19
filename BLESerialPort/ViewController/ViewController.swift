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
    
    var prefs = Preferencs()
    var inputText = InputText()
    var cycleData = CycleSend()
    
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
            self.outputTextView.string += "[\(getNowTime())] " + hexToString(hex: data) + "\n"
            self.outputTextView.scrollRangeToVisible(NSRange.init(location: self.outputTextView.string.count, length: 1))
            if let inputLine = self.inputText.getLineNumber(form: hexToString(hex: data)) {
                if let outputLine = self.cycleData.getSendLine(form: "\(inputLine + 1)") {
                    if let outputString = self.inputTextView.stringForLineNumber(lineNumber: outputLine) {
                        Logger.info(outputString)
                        self.peripheralManager?.sendData(data: stringToHexArray(str: outputString))
                    }
                }
            }

            
        })
        setupPrefs()
        //_ = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(ViewController.sendData) , userInfo: nil, repeats: true)
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
    
}

extension ViewController {
    @objc func sendData(t:Timer)->Bool{
        peripheralManager?.sendData(data: [1, 2, 3])
        return true
    }
    
    @IBAction func sendMenuItemSelected(_ sender: Any) {
        Logger.info("\(sender)")
        guard let selectString = self.inputTextView.stringForSelectLine() else {
            openAlertPanel(infoTest: "请选择发送行")
            return
        }
        
        guard checkString(str: selectString) else {
            openAlertPanel(infoTest: "当前选择行数据错误")
            return
        }
        
        Logger.info(selectString)
        let data = stringToHexArray(str: selectString)
        peripheralManager?.sendData(data: data)
    }
    
    @IBAction func showConditionalWindow(_ sender: Any) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Auto"), bundle: nil)
        let conditionalController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "CycleSendWindow")) as! NSWindowController
        if let window = conditionalController.window {
            let application = NSApplication.shared
            application.runModal(for: window)
            window.close()
        }
//        self.presentViewControllerAsSheet(ConditionalController())
    }
    
    func openAlertPanel(infoTest: String) {
        let alert = NSAlert()

        alert.addButton(withTitle: "Cancel")
        alert.messageText = "错误"
        alert.informativeText = infoTest
        alert.alertStyle = NSAlert.Style.critical
        alert.runModal()
    }
}

extension ViewController {
    func setupPrefs() {
        updateFormPrefs()
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (notification) in
                                                self.updateFormPrefs()
        }

    }
    
    func updateFormPrefs() {
        // Set BLE UUID
        peripheralManager?.ServiceUUID = prefs.serviceUUID
        //peripheralManager?.notiyCharacteristicUUID = prefs.characUUID
        // Restart BLE advertising
        
        Logger.info("\(String(describing: peripheralManager?.isAdvertising))")
        if (peripheralManager?.isAdvertising)! {
            peripheralManager?.stopAdvertising()
            peripheralManager?.publishService()
        }
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
    
    func textView(_ textView: NSTextView, clickedOn cell: NSTextAttachmentCellProtocol, in cellFrame: NSRect, at charIndex: Int) {
        Logger.info("\(cell)")
    }
    
    func textViewDidChangeSelection(_ notification: Notification) {
        // 当前光标所选内容发生改变
        Logger.info("\(notification)")
        if (inputText.str != inputTextView.string) {
            inputText.str = inputTextView.string
        }
        //inputTextView.textStorage?.font = NSFont(name: "Lucida Sans", size: 11)
    }
}

