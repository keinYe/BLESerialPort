//
//  PreferenceWindowController.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/6/29.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Cocoa

class PreferenceWindowController: NSWindowController {
    static let shared = PreferenceWindowController()

    private let viewControllers : [NSViewController] = [
        "GeneralPanel",
        "TriggerPanel",
    ]
    .map { NSStoryboard.Name($0) }
    .map { NSStoryboard(name: $0, bundle: nil).instantiateInitialController() as! NSViewController }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("PreferenceWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let item = self.window?.toolbar?.items.first else {
            Logger.info("error")
            return
        }
        self.window?.toolbar?.selectedItemIdentifier = item.itemIdentifier
        self.switchView(item)
        self.window?.center()
    }
    
    @IBAction func switchView(_ toolbarItem: NSToolbarItem) {
        // detect clicked icon and select the view to switch
        let newController = self.viewControllers[toolbarItem.tag]
        
        guard
            let window = self.window,
            newController != window.contentViewController
            else { return }
        
        // remove current view from the main view
        window.contentViewController = nil
        
        // resize window to fit to new view
        var frame = window.frameRect(forContentRect: newController.view.frame)
        frame.origin = window.frame.origin
        frame.origin.y += window.frame.height - frame.height
        window.setFrame(frame, display: false, animate: true)
        
        // set window title
        window.title = toolbarItem.paletteLabel
        
        // add new view to the main view
        window.contentViewController = newController
    }
}
