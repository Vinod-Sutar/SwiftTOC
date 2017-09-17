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
    var name: String = ""
    
    init(_ guidelineName: String) {
        
        name = guidelineName
    }
}
