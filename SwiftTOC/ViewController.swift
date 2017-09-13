//
//  ViewController.swift
//  SwiftTOC
//
//  Created by Vinod on 09/09/17.
//  Copyright © 2017 Vinod Sutar. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var rootChapters: [Chapter] = []
    
    @IBOutlet var splitView: NSSplitView!
    
    @IBOutlet var tocOutlineView: GuidelineOutlineView!
    
    @IBOutlet var chapterEditView: ChapterEditViewController!
    
    @IBOutlet var treeController: NSTreeController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonFilePath1 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath2 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath3 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath4 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        
        setData("Arthritis", guidelinTocPath: jsonFilePath1!)
        setData("Chronic Pancreatitis", guidelinTocPath: jsonFilePath2!)
        setData("Valvular heart disease", guidelinTocPath: jsonFilePath3!)
        setData("Peripheral heart disease", guidelinTocPath: jsonFilePath4!)
        
    }
    
    override func viewWillAppear() {
        
        //tocOutlineView.expandItem(nil, expandChildren: true)
        
        
    }
    
    func setData(_ guidelineName: String, guidelinTocPath: String) {
        
        let root = [
            "name": guidelineName,
            "isChapter": false
            ] as [String : Any]
        
        let dict:NSMutableDictionary = NSMutableDictionary(dictionary: root)
        
        rootChapters = TocCreator().getRootChapter(URL(fileURLWithPath: guidelinTocPath))
        
        dict.setObject(rootChapters, forKey: "chapters" as NSCopying)
        
        treeController.addObject(dict)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func editChapter() {
        
        print("Edit clicked")
    }
    
    func deleteChapter() {
        
        print("Delete clicked")
    }
}


extension ViewController: NSOutlineViewDataSource {

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            return 1;
        }
        
        return rootChapters.count;
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        
        if let item = item as? Chapter,
            item.chapters.count > index {
            return item.chapters[index]
        }
        
        return ""
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let item = item as? Chapter else {
            
            return false
        }
        
        return !item.chapters.isEmpty
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        guard let item = item as? Chapter else {
            
            return nil
        }
        
        let v = outlineView.make(withIdentifier: "DataCell", owner: self) as! NSTableCellView
        
        if let tf = v.textField {
            
            tf.stringValue = item.name
            
            tf.textColor = NSColor.yellow
        }
        
        return v
    }
}


extension ViewController: NSOutlineViewDelegate {
    
    func isHeader(_ item: Any) -> Bool {
        
        if let item = item as? NSTreeNode {
            
            return !(item.representedObject is Chapter)
        }
        else {

            return !(item is Chapter)
        }
    }
 
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        if isHeader(item) {
            
            return outlineView.make(withIdentifier: "HeaderCell", owner: self)
        }
        else {
            
            return outlineView.make(withIdentifier: "DataCell", owner: self)
        }
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    
        return true;
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        
        let tableView = notification.object
        
        if tableView is NSTableView,
            case let tableView = tableView as! NSTableView {
            
            let clickedRowInTableView = tableView.selectedRow
            
            let selectedItem = tocOutlineView.item(atRow: clickedRowInTableView)
            
            if let selectedItem = selectedItem as? NSTreeNode {
                
                if let representedObject = selectedItem.representedObject,
                    representedObject is Chapter,
                    case let selectedChapter = representedObject as! Chapter{
                    
                    
                    if selectedChapter.isChapter() {
                        
                        //print("clickedRowInTableView: \(selectedChapter.name!)")
                        
                        if let chapterEditViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterEditViewController")  as? ChapterEditViewController {
                            
                            chapterEditViewController.currentEditChapter = selectedChapter
                            self.presentViewControllerAsSheet(chapterEditViewController)
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
}

