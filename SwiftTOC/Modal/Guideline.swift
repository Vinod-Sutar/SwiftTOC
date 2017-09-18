//
//  Guideline.swift
//  SwiftTOC
//
//  Created by Vinod on 17/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class Guideline: NSObject {
    
    var id: String = ""
    var uniqueId: String = ""
    var name: String = ""
    var app: App!
    var rootChapters: NSArray = []
    
    init(_ dictionary: NSDictionary, app: App) {
        
        id  = dictionary["gl_id"] as! String
        uniqueId = dictionary["unique_id"] as! String
        name = dictionary["gl_name"] as! String
        self.app = app
    }
}
