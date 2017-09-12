//
//  TocCreator.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class TocCreator: NSObject {
    
    func createTree(_ chapter: Chapter, chapterArray: NSArray) -> Chapter {
        
        for chapterDict in chapterArray {
            
            if chapterDict is NSDictionary,
                case let chapterDict = chapterDict as! NSDictionary {
                
                let newChapter = Chapter(chapterDict)
                
                if chapterDict["chapters"] is NSArray,
                    case let chaptersArray = chapterDict["chapters"] as! NSArray {
                    
                    chapter.chapters.append(createTree(newChapter, chapterArray: chaptersArray));
                }
            }
        }
        
        return chapter;
    }
    
    func getRootChapter(_ jsonURL: URL) -> [Chapter]! {
        
        do {
            
            let jsonString = try String(contentsOf: jsonURL, encoding: String.Encoding.utf8)
            
            let data = jsonString.data(using: .utf8)!
            
            let rootChapters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
            
            let rootChapter = Chapter();
            
            return createTree(rootChapter, chapterArray: rootChapters!).chapters
            
        } catch let error {
            
            print("Error!! Unable to parse  \(error.localizedDescription)")
            
        }
        
        return nil
    }
}
