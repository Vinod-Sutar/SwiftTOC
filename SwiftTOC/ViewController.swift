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
    
    @IBOutlet var rightPaneContainerView: NSView!
    
    @IBOutlet var treeController: NSTreeController!
    
    var currentRightPaneViewController: NSViewController!
    
    var quickHelpViewController: NSViewController!
    
    var selectedChapterEditViewController: ChapterEditViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(guidelineListUpdated), name: NSNotification.Name(rawValue: "GuidelineListUpdate"), object: nil)
        
        let jsonFilePath1 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath2 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath3 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        let jsonFilePath4 = Bundle.main.path(forResource: "DummyToc", ofType: "json")
        
        setData("Arthritis", guidelinTocPath: jsonFilePath1!)
        setData("Chronic Pancreatitis", guidelinTocPath: jsonFilePath2!)
        setData("Valvular heart disease", guidelinTocPath: jsonFilePath3!)
        setData("Peripheral heart disease", guidelinTocPath: jsonFilePath4!)
        
        quickHelpViewController = self.storyboard?.instantiateController(withIdentifier: "QuickHelpViewController") as! NSViewController
        
        selectedChapterEditViewController = self.storyboard?.instantiateController(withIdentifier: "ChapterEditViewController") as! ChapterEditViewController
        
    }
    
    override func viewWillAppear() {
        
        //tocOutlineView.expandItem(nil, expandChildren: true)
        
        
    }
    
    func guidelineListUpdated() {
        
        tocOutlineView.reloadData()
    }
    
    func setData(_ guidelineName: String, guidelinTocPath: String) {
        
        let root = [
            "name": guidelineName,
            "isChapter": false
            ] as [String : Any]
        
        let dict:NSMutableDictionary = NSMutableDictionary(dictionary: root)
        
        let guideline = Guideline(guidelineName)
        
        
        rootChapters = TocCreator().getRootChapter(guideline, jsonURL: URL(fileURLWithPath: guidelinTocPath))
        
        dict.setObject(rootChapters, forKey: "chapters" as NSCopying)
        
        treeController.addObject(dict)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setRightPaneWithControllerWithChapter(_ chapter: Chapter!) {
        
        if currentRightPaneViewController != nil {
            
            currentRightPaneViewController.view.removeFromSuperview()
            currentRightPaneViewController.removeFromParentViewController()
        }
        
        
        if chapter != nil {
            
            selectedChapterEditViewController.currentEditChapter = chapter
            
            self.addChildViewController(selectedChapterEditViewController)
            selectedChapterEditViewController.view.frame = rightPaneContainerView.frame
            rightPaneContainerView .addSubview(selectedChapterEditViewController.view)
            currentRightPaneViewController = selectedChapterEditViewController
        }
        else if quickHelpViewController != nil{
            
            self.addChildViewController(quickHelpViewController)
            quickHelpViewController.view.frame = rightPaneContainerView.frame
            rightPaneContainerView .addSubview(quickHelpViewController.view)
            currentRightPaneViewController = quickHelpViewController
        }
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
        
        
        var isSet = false
        
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
                        
                        isSet = true
                        
                        setRightPaneWithControllerWithChapter(selectedChapter)
                    }
                }
            }
        }
        
        if isSet == false {
            
            setRightPaneWithControllerWithChapter(nil)
        }
    }
}



