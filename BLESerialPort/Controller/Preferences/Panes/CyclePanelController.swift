//
//  CyclePanelController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/7/4.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class CyclePanelController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var assignLineButton: NSButton!
    @IBOutlet weak var currentLineButton: NSButton!
    @IBOutlet weak var fixedLineButton: NSButton!
    @IBOutlet weak var rangeLineButton: NSButton!
    
    @IBOutlet weak var fiexdLineTextField: NSTextField!
    @IBOutlet weak var rangeLineStartTextField: NSTextField!
    @IBOutlet weak var rangeLineEndTextField: NSTextField!
    @IBOutlet var userDefault: NSUserDefaultsController!
    
    private var cycle = Cycle()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        cycle.enable = false
        if cycle.enableLine {
            rangeLineStartTextField.isEnabled = false
            rangeLineEndTextField.isEnabled = false
        } else {
            rangeLineStartTextField.isEnabled = true
            rangeLineEndTextField.isEnabled = true
            rangeLineButton.state = .on
        }
        
        if cycle.enableCurrentLine {
            fiexdLineTextField.isEnabled = false
        } else {
            fiexdLineTextField.isEnabled = true
            fixedLineButton.state = .on
        }
        
        fiexdLineTextField.delegate = self
        rangeLineEndTextField.delegate = self
        rangeLineStartTextField.delegate = self
    }
    
    @IBAction func cycleCheckButtonClick(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }
        
        switch button.tag {
        case 1:
            rangeLineEndTextField.isEnabled = false
            rangeLineStartTextField.isEnabled = false
            if cycle.enableCurrentLine {
                fiexdLineTextField.isEnabled = false
            } else {
                fiexdLineTextField.isEnabled = true
            }
        case 2:
            fiexdLineTextField.isEnabled = false
            rangeLineEndTextField.isEnabled = true
            rangeLineStartTextField.isEnabled = true
            cycle.enableLine = false
        default:
            break
        }
    }
    
    @IBAction func cycleSendLineButtonClick(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }
        switch button.tag {
        case 1:
            fiexdLineTextField.isEnabled = false
        case 2:
            fiexdLineTextField.isEnabled = true
            cycle.enableCurrentLine = false
        default:
            break
        }
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        userDefault.save(nil)
    }
    
}
