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
    
    var peripheralManager: BLEPeripheral?
    
    @IBOutlet weak var outputScrollView: NSScrollView!
    @IBOutlet var outputTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputScrollView.scrollerStyle = .overlay
        outputScrollView.hasVerticalRuler = true
        outputScrollView.hasHorizontalRuler = true
        outputScrollView.scrollerKnobStyle = .dark
        outputScrollView.horizontalScrollElasticity = .automatic
        outputScrollView.verticalScrollElasticity = .automatic
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        peripheralManager = BLEPeripheral()
        
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

