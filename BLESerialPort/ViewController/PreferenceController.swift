//
//  PreferenceController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/5.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class PreferenceController: NSViewController {

    @IBOutlet weak var UUIDTextField: NSTextField!
    @IBOutlet weak var CharacUUIDTextField: NSTextField!
    
    var prefs = Preferencs()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do view setup here.
        UUIDTextField.stringValue = prefs.serviceUUID
        CharacUUIDTextField.stringValue = prefs.characUUID
        
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
    }
    @IBAction func okButton(_ sender: Any) {
        saveNewPrefs()
        self.view.window?.close()
    }
    
    func saveNewPrefs() {
        prefs.serviceUUID = UUIDTextField.stringValue
        prefs.characUUID = CharacUUIDTextField.stringValue
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                        object: nil)
    }
}
