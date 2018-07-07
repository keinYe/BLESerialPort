//
//  LineNumberTextView.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/26.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class LineNumberTextView: NSTextView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func updateRuler() {
        self.lnv_setUpLineNumberView()
    }
}
