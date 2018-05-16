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
        Logger.info("DidLoad")
        inputTextView.delegate = self
        //outputTextView.setAccessibilityEdited(false)
        outputTextView.string = "test"
        
        inputTextView.lnv_setUpLineNumberView()
        
        
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        Logger.info("DidAppear")
        peripheralManager = BLEPeripheral()
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
        Logger.info("\(notification)")
        
        // 获取所选行内容
        
        let selectedRanges:NSArray = inputTextView.selectedRanges as NSArray
        let text:NSString = inputTextView.string as NSString
        
        if selectedRanges.count > 0 {
            let range:NSRange = selectedRanges.firstObject as! NSRange
            let v = text.lineRange(for: NSRange(location: range.location + range.length, length: 0))
            let x = text.substring(with: v)
            Logger.info("\(selectedRanges)  \(text)  \(range)  \(v)  \(x)")
        }
        
    }
    

    
}

