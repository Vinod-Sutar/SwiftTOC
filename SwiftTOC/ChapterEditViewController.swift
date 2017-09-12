//
//  ChapterEditViewController.swift
//  SwiftTOC
//
//  Created by Vinod on 11/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class ChapterEditViewController: NSViewController {

    var currentEditChapter: Chapter!
    
    @IBOutlet var chapterNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        chapterNameTextField.stringValue = "Hel"
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        self.dismiss(nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        currentEditChapter.setChapterName(chapterNameTextField.stringValue)
        
        if self.presenting is ViewController,
             let viewController = self.presenting as? ViewController {
            
            viewController.tocOutlineView.reloadData()
            
        }
        
        self.dismiss(self)
    }
}
