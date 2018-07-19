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

extension NSTextView {
    var lineNumberView:LineNumberRulerView {
        get {
            return objc_getAssociatedObject(self, &LineNumberViewAssocObjKey) as! LineNumberRulerView
        }
        set {
            objc_setAssociatedObject(self, &LineNumberViewAssocObjKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func clearDisplay() {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        self.textStorage?.setAttributedString(attrString)
        self.lnv_setUpLineNumberView()
    }
    
    func appendColorString(str: String, color : NSColor?) {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedString())
        
        let attrs = [NSAttributedStringKey.font : self.font ?? NSFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: color ?? NSColor.black] as [NSAttributedStringKey : Any]
        let appendString = NSMutableAttributedString(string: str, attributes: attrs)
        
        attrString.append(appendString)
        
        self.textStorage?.setAttributedString(attrString)
        self.lnv_setUpLineNumberView()
    }
    
    func lnv_setUpLineNumberView() {
        if font == nil {
            font = NSFont.systemFont(ofSize: 16)
        }
        
        if let scrollView = enclosingScrollView {
            lineNumberView = LineNumberRulerView(textView: self)
            
            scrollView.verticalRulerView = lineNumberView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
        }
        
        postsFrameChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(lnv_framDidChange), name: NSView.frameDidChangeNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(lnv_textDidChange), name: NSText.didChangeNotification, object: self)
    }
    
    @objc func lnv_framDidChange(notification: NSNotification) {
        
        lineNumberView.needsDisplay = true
    }
    
    @objc func lnv_textDidChange(notification: NSNotification) {
        
        lineNumberView.needsDisplay = true
    }
    
    func stringForLineNumber(lineNumber: Int) -> String? {
        guard lineNumber > 0 else {
            return nil
        }
        let splitedArrary = self.string.components(separatedBy: "\n").map{$0.trimmingCharacters(in: .whitespaces)}
        let number = lineNumber - 1
        return splitedArrary[number]
    }
    
    func stringForSelectLine() -> String? {
        let selectedRanges:NSArray = self.selectedRanges as NSArray
        let text:NSString = string as NSString
        
        if selectedRanges.count > 0 {
            let range:NSRange = selectedRanges.firstObject as! NSRange
            let v = text.lineRange(for: NSRange(location: range.location + range.length, length: 0))
            let x = text.substring(with: v).trimmingCharacters(in: .newlines)
            return x
        }
        return nil
    }
    
    func forSelect() -> (String?, NSRange?) {
        let select:NSArray = self.selectedRanges as NSArray
        let text:NSString = string as NSString
        
        if select.count > 0 {
            let range:NSRange = select.firstObject as! NSRange
            let v = text.substring(with: range)
            return (v, range)
        }
        return (nil, nil)
    }
    
    func insertString(subString: String, offsetBy: Int) {
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedString())
        
        let attrs = [NSAttributedStringKey.font : self.font ?? NSFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: NSColor.black] as [NSAttributedStringKey : Any]
        let appendString = NSMutableAttributedString(string: subString, attributes: attrs)
        
        attrString.insert(appendString, at: offsetBy)
        
        self.textStorage?.setAttributedString(attrString)
        //self.lnv_setUpLineNumberView()
        
    }
}
