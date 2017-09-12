//
//  Chapter.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class Chapter: NSObject {
    
    let id: String!
    var name: String!
    let htmlPage: String!
    var chapters: [Chapter]!
    var textColor = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    
    override init() {
        
        id = nil
        name = ""
        htmlPage = ""
        chapters = []
    }
    
    init(_ chapterDictionary: NSDictionary) {
        
        id = chapterDictionary["id"] as? String
        name = chapterDictionary["name"] as? String
        htmlPage = chapterDictionary["htmlPage"] as? String
        chapters = []
        
    }
    
    func tocDisplayName() -> String {
        return isChapter() ? "📄 \(name!)" : name
    }
    
    func isChapter() -> Bool {
        return chapters.count == 0
    }
    
    func setChapterName(_ chapterName: String) {
        
        name = chapterName
    }
    
}
