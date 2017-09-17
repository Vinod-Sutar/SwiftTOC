//
//  GuidelineTOCDownloader.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa


protocol GuidelineTOCDownloaderDelegate {
    
    func didReceivedGuidelineTOC(_ guideline: Guideline, tocArray: NSArray)
}

class GuidelineTOCDownloader: NSObject {

    static let shared = GuidelineTOCDownloader()
    
    override init() {
        
    }
    
    func downloadTOC(_ ofGuideline: Guideline) {
        
        
    }
}
