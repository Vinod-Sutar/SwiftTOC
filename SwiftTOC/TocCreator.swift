//
//  TocCreator.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class TocCreator: NSObject {
    
    var oldChapters:[Chapter] = []
    
    
    //Mark - This is new TOC methods
    
    func getRootChapter(_ guideline: Guideline, jsonURL: URL) -> [Chapter]! {
        
        do {
            
            let jsonString = try String(contentsOf: jsonURL, encoding: String.Encoding.utf8)
            
            let data = jsonString.data(using: .utf8)!
            
            let rootChapters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
            
            let rootChapter = Chapter();
            
            
            return createTreeWithOldTOC(guideline, chapter:rootChapter, chapterArray: rootChapters!).chapters
            
            //return createTreeWithNewTOC(guideline, chapter:rootChapter, chapterArray: rootChapters!).chapters
            
        } catch let error {
            
            print("Error!! Unable to parse  \(error.localizedDescription)")
            
        }
        
        return nil
    }
    
    
    func createTreeWithOldTOC(_ guideline: Guideline, chapter: Chapter, chapterArray: NSArray) -> Chapter {
        
        for chapterDict in chapterArray {
            
            if chapterDict is NSDictionary,
                case let chapterDict = chapterDict as! NSDictionary {
                
                let newChapter = Chapter(guideline, oldChapterDictionary: chapterDict)
                
                //print("Chapter Id: \(newChapter.numTree)")
                
                oldChapters.append(newChapter)
            }
        }
        
        let mainChapters = oldChapters.filter{ $0.numTree.hasSuffix(".0.0.0")}

        for mainChapter in mainChapters {
            
            let mainChapterIndex = mainChapter.numTree.components(separatedBy: ".")[0]
            
            let mainLevelPrefixString = "\(mainChapterIndex)."
            
            let secondLevelChapters:[Chapter] = oldChapters.filter{ $0.numTree.hasPrefix(mainLevelPrefixString)}.filter{ $0.numTree.hasSuffix(".0.0")}
            
            for secondLevelChapter in secondLevelChapters {
                
                if mainChapter != secondLevelChapter {
                    
                    let secondLevelIndex = secondLevelChapter.numTree.components(separatedBy: ".")[1]
                    
                    let secondLevelPrefixString = "\(mainChapterIndex).\(secondLevelIndex)."
                    
                    let thirdLevelChapters:[Chapter] = oldChapters.filter{ $0.numTree.hasPrefix(secondLevelPrefixString)}.filter{ $0.numTree.hasSuffix(".0")}
                    
                    for thirdLevelChapter in thirdLevelChapters {
                        
                        if secondLevelChapter != thirdLevelChapter {
                            
                            let thirdLevelIndex = thirdLevelChapter.numTree.components(separatedBy: ".")[2]
                            
                            let thirdLevelPrefixString = "\(mainChapterIndex).\(secondLevelIndex).\(thirdLevelIndex)."
                            
                            let fourthLevelChapters:[Chapter] = oldChapters.filter{ $0.numTree.hasPrefix(thirdLevelPrefixString)}
                            
                            for fourthLevelChapter in fourthLevelChapters {
                                
                                if thirdLevelChapter != fourthLevelChapter {
                                    
                                    thirdLevelChapter.chapters.append(fourthLevelChapter)
                                }
                            }
                            
                            secondLevelChapter.chapters.append(thirdLevelChapter)
                        }
                    }
                    
                    
                    mainChapter.chapters.append(secondLevelChapter)
                }
            }
        }
        
        
        chapter.chapters = mainChapters
        
        oldChapters.removeAll()
        
        return chapter;
    }
    
    
    
    func createTreeWithNewTOC(_ guideline: Guideline, chapter: Chapter, chapterArray: NSArray) -> Chapter {
        
        for chapterDict in chapterArray {
            
            if chapterDict is NSDictionary,
                case let chapterDict = chapterDict as! NSDictionary {
                
                let newChapter = Chapter(guideline, chapterDictionary: chapterDict)
                
                if chapterDict["chapters"] is NSArray,
                    case let chaptersArray = chapterDict["chapters"] as! NSArray {
                    
                    chapter.chapters.append(createTreeWithNewTOC(guideline, chapter:newChapter, chapterArray: chaptersArray));
                }
            }
        }
        
        return chapter;
    }
    
    
    //Mark - This is new TOC methods
}
