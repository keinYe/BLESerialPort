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
        Logger.info("\(sender)")
        guard let check = sender as? NSButton else {
            return
        }
        Logger.info("\(check.state)")
        if check.state == .on {
            UserDefaults.Trigger.set(value: arraryController.arrangedObjects as? [NSMutableDictionary], forKey: .trigger)
            trigger.enable = true
        } else {
            trigger.enable = false
        }
    }
    
    
}
