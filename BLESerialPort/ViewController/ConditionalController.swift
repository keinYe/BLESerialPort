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
            let data = cycleData.filter { data in
                return (!data.input.isEmpty && Int(data.input) == nil) || (!data.output.isEmpty && Int(data.output) == nil)
            }
            Logger.info("\(data.count)")
            guard data.count == 0 else {
                return
            }
            cycle.data = cycleData
        }
        else if sender.title == "Cancel" {
            cycleData = cycle.data
        }
        Logger.info("\(sender.title)")
//        self.dismiss(sender)
        NSApplication.shared.stopModal()
    }
}

