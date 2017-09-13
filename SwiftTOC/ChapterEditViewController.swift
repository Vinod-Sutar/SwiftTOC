//
//  ChapterEditViewController.swift
//  SwiftTOC
//
//  Created by Vinod on 11/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class ChapterEditViewController: NSViewController {

    var currentEditChapter = Chapter()
    
    @IBOutlet var chapterNameTextField: NSTextField!
    
    @IBOutlet var tocChapterNameTextField: NSTextField!
    
    @IBOutlet var PDFEnabledButton: NSButton!
    
    @IBOutlet var mailEnabledButton: NSButton!
    
    
    @IBOutlet var recipientsTextField: NSTextField!
    
    @IBOutlet var subjectTextField: NSTextField!
    
    @IBOutlet var bodyTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        chapterNameTextField.stringValue = currentEditChapter.name
        tocChapterNameTextField.placeholderString = currentEditChapter.name
        tocChapterNameTextField.stringValue = currentEditChapter.tocName
        
        mailEnabledButton.state = currentEditChapter.mailEnabled ? NSOnState : NSOffState
        PDFEnabledButton.state = currentEditChapter.PDFEnabled ? NSOnState : NSOffState
        
        self.mailEnabledClicked(mailEnabledButton)
    }
    
    @IBAction func mailEnabledClicked(_ sender: Any) {
        
        var isEnabled = false
        
        if mailEnabledButton.state == NSOnState {
            
            isEnabled = true
        }
        
        recipientsTextField.isEnabled = isEnabled
        subjectTextField.isEnabled = isEnabled
        bodyTextField.isEnabled = isEnabled
        
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        self.dismiss(nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        currentEditChapter.setChapterName(chapterNameTextField.stringValue)
        currentEditChapter.tocName = tocChapterNameTextField.stringValue
        currentEditChapter.mailEnabled = mailEnabledButton.state == NSOnState ? true : false
        currentEditChapter.PDFEnabled = PDFEnabledButton.state == NSOnState ? true : false
        
        if self.presenting is ViewController,
             let viewController = self.presenting as? ViewController {
            
            viewController.tocOutlineView.reloadItem(currentEditChapter, reloadChildren: true)
            
        }
        
        self.dismiss(self)
    }
}

extension ChapterEditViewController : NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        
        tocChapterNameTextField.placeholderString = chapterNameTextField.stringValue
    }
}
