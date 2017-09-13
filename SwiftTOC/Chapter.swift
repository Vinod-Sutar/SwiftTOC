//
//  Chapter.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class Chapter: NSObject {
    
    var id: String = ""
    var name: String = ""
    var tocName: String = ""
    var mailEnabled: Bool = false
    var PDFEnabled: Bool = false
    var htmlPage: String = ""
    var chapters: [Chapter] = []
    var textColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    
    override init() {
    }
    
    init(_ chapterDictionary: NSDictionary) {
        
        id = chapterDictionary["id"] as! String
        name = chapterDictionary["name"] as! String
        htmlPage = chapterDictionary["htmlPage"] as! String
        
        if let isMailEnabled = chapterDictionary["mailEnabled"] {
            
            mailEnabled = isMailEnabled as! Bool
        }
        
        if let isPDFEnabled = chapterDictionary["PDFEnabled"] {
            
            PDFEnabled = isPDFEnabled as! Bool
        }
        
    }
    
    func tocDisplayName() -> String {
        
        var emojiString = ""
        
        if isChapter() {
            emojiString = "📋"
        }
        
        if mailEnabled {
            emojiString = emojiString + "📪"
        }
        
        if PDFEnabled {
            emojiString = emojiString + "📚"
        }
        
        return isChapter() ? emojiString + " " + name : name
    }
    
    func isChapter() -> Bool {
        return chapters.count == 0
    }
    
    func setChapterName(_ chapterName: String) {
        
        name = chapterName
    }
    
}
