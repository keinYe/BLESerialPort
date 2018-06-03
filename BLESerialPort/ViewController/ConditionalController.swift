//
//  ConditionalController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/28.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class ConditionalController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var arraryController: NSArrayController!
    
    var cycle = CycleSend()
    @objc dynamic var cycleData = [CycleData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cycleData = cycle.data
    }
    
    override func viewDidAppear() {
        
    }
    
}

extension ConditionalController {
    @IBAction func dismissConditionalWindow(_ sender: NSButton) {
        if sender.title == "OK" {
            cycle.data = cycleData
        }
        
        let application = NSApplication.shared
        application.stopModal()
        Logger.info("\(sender.title)")
        
        
    }
}

