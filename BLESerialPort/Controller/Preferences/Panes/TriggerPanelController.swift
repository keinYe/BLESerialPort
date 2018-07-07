//
//  CycleSendPanelController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/30.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class TriggerPanelController: NSViewController {
    @IBOutlet var arraryController: NSArrayController!
    
    private var trigger = Trigger()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        trigger.enable = false
    }
    
    
    @IBAction func triggerEnableClick(_ sender: Any) {
        guard let check = sender as? NSButton else {
            return
        }
        if check.state == .on {
            UserDefaults.Trigger.set(value: arraryController.arrangedObjects as? [NSMutableDictionary], forKey: .trigger)
        }
    }
    
    @IBAction func triggerMenuEnableClick(_ sender: Any) {
        guard let menu = sender as? NSMenuItem else {
            return
        }
        if menu.state == .on {
             UserDefaults.Trigger.set(value: arraryController.arrangedObjects as? [NSMutableDictionary], forKey: .trigger)
        }
    }
    
    
}
