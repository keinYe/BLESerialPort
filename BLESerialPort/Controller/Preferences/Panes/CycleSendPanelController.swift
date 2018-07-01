//
//  CycleSendPanelController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/30.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class CycleSendPanelController: NSViewController {
    @IBOutlet var arraryController: NSArrayController!
    
    @objc dynamic var cycleData = CycleSend().data
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
