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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //inputTextView.delegate = self
        inputTextView.lnv_setUpLineNumberView()
        outputTextView.lnv_setUpLineNumberView()
        //outputTextView.layoutManager?.allowsNonContiguousLayout = false
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        Logger.info("DidAppear")
        peripheralManager = BLEPeripheral()
        peripheralManager?.registerReciveData(call: {uuid, data in
            self.outputTextView.string += hexToString(hex: data) + "\n"
            self.outputTextView.scrollRangeToVisible(NSRange.init(location: self.outputTextView.string.count, length: 1))
            
        })
        setupPrefs()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(ViewController.sendData) , userInfo: nil, repeats: true)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    @objc func sendData(t:Timer)->Bool{
        peripheralManager?.sendData(data: [1, 2, 3])
        return true
    }
    
    @IBAction func sendMenuItemSelected(_ sender: Any) {
        guard let selectString = self.inputTextView.stringForSelectLine() else {
            openAlertPanel()
            return
        }
        
        guard checkString(str: selectString) else {
            openAlertPanel()
            return
        }
        
        Logger.info(selectString)
        let data = stringToHexArray(str: selectString)
        peripheralManager?.sendData(data: data)
    }
    
    @IBAction func showConditionalWindow(_ sender: Any) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Auto"), bundle: nil)
        let conditionalController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ConditionalWindow")) as! NSWindowController
        if let window = conditionalController.window {
            let application = NSApplication.shared
            application.runModal(for: window)
            window.close()
        }
    }
    
    func openAlertPanel() {
        let alert = NSAlert()

        alert.addButton(withTitle: "Cancel")
        alert.messageText = "错误"
        alert.informativeText = "发送数据错误"
        alert.alertStyle = NSAlert.Style.critical
        alert.runModal
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
        peripheralManager?.notiyCharacteristicUUID = prefs.characUUID
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
    }
}

