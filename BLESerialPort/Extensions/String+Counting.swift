//
//  String+Counting.swift
//  BLESerialPort
//
//  Created by keinYe on 2018/5/16.
//  Copyright © 2018年 keinYe. All rights reserved.
//

import Foundation

extension String {
    
    /// number of composed characters in the whole string
    var numberOfComposedCharacters: Int {
        
        return self.countComposedCharacters()
    }
    
    
    ///
    func countComposedCharacters(_ body: ((_ stop: inout Bool) -> Void)? = nil) -> Int {
        
        guard !self.isEmpty else { return 0 }
        
        // normalize using NFC
        let string = self.precomposedStringWithCanonicalMapping
        
        var count = 0
        string.enumerateSubstrings(in: string.startIndex..<string.endIndex, options: [.byComposedCharacterSequences, .substringNotRequired]) { (_, _, _, stop) in
            count += 1
            body?(&stop)
        }
        
        return count
    }
    
    
    /// number of words in the whole string
    var numberOfWords: Int {
        
        guard !self.isEmpty else { return 0 }
        
        let range = CFRange(location: 0, length: CFStringGetLength(self as CFString))
        let locale = CFLocaleCopyCurrent()
        
        guard let tokenizer = CFStringTokenizerCreate(nil, self as CFString, range, kCFStringTokenizerUnitWord, locale) else { return 0 }
        
        var count = 0
        while !CFStringTokenizerAdvanceToNextToken(tokenizer).isEmpty {
            count += 1
        }
        
        return count
    }
    
    
    /// number of lines in the whole string ignoring the last new line character
    var numberOfLines: Int {
        
        return self.numberOfLines(in: self.startIndex..<self.endIndex, includingLastLineEnding: false)
    }
    
    
    /// count the number of lines in the range
    func numberOfLines(in range: NSRange, includingLastLineEnding: Bool) -> Int {
        
        guard let characterRange = Range(range, in: self) else { return 0 }
        
        return self.numberOfLines(in: characterRange, includingLastLineEnding: includingLastLineEnding)
    }
    
    
    /// count the number of lines in the range
    func numberOfLines(in range: Range<String.Index>, includingLastLineEnding: Bool) -> Int {
        
        guard !self.isEmpty, !range.isEmpty else { return 0 }
        
        var count = 0
        self.enumerateSubstrings(in: range, options: [.byLines, .substringNotRequired]) { (_, _, _, _) in
            count += 1
        }
        
        if includingLastLineEnding,
            let last = self[range].unicodeScalars.last,
            CharacterSet.newlines.contains(last)
        {
            count += 1
        } 
        
        return count
    }
    
    
    /// count the number of lines at the character index (1-based).
    func lineNumber(at location: Int) -> Int {
        
        guard !self.isEmpty, location > 0 else { return 1 }
        
        return self.numberOfLines(in: NSRange(location: 0, length: location), includingLastLineEnding: true)
    }
    
}
