//
// MainWindowController.swift
// Iconizer
// https://github.com/behoernchen/Iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Cocoa


///  Handles the MainWindow view.
class MainWindowController: NSWindowController, NSWindowDelegate {
    
    /// Holds the main view of the MainWindow.
    @IBOutlet weak var mainView: NSView!
    /// Points to the SegmentedControl, which determines which view is currently selected.
    @IBOutlet weak var exportType: NSSegmentedControl!
    /// Represents the currently selected view.
    var currentView: NSViewController?
    
    // Override the windowNibName property.
    override var windowNibName: String {
        return "MainWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Hide the window title, to get the unified toolbar.
        self.window!.titleVisibility = .Hidden
        
        // Set the default view.
        let prefManager = PreferenceManager()
        // Select the correct view...
        self.changeView(ViewControllerTag(rawValue: prefManager.selectedExportType))
        // ...and set the selectedSegment of NSSegmentedControl to the corresponding value.
        self.exportType.selectedSegment = prefManager.selectedExportType
    }
    
    // Save the user preferences before the application terminates.
    func windowWillClose(notification: NSNotification) {
        let prefManager = PreferenceManager()
        prefManager.selectedExportType = self.exportType.selectedSegment
    }
    
    
    ///  Select the export type.
    ///
    ///  - parameter sender: NSSegmentedControl; 'Mode' set to 'Select One'.
    @IBAction func selectView(sender: NSSegmentedControl) {
        changeView(ViewControllerTag(rawValue: sender.selectedSegment))
    }
    
    ///  Kick off exporting for the selected export type.
    ///
    ///  - parameter sender: NSButton responsible for exporting.
    @IBAction func export(sender: NSButton) {
        // Unwrap the export view.
        guard let currentView = self.currentView else {
            return
        }
        
        do {
            // Generate the required images.
            try currentView.generateRequiredImages()
            
            // Misuse an NSOpenPanel as export panel.
            let exportSheet = NSOpenPanel()
            
            // Configure the "export sheet".
            exportSheet.canChooseDirectories = true
            exportSheet.canChooseFiles       = false
            exportSheet.prompt               = "Export"
            
            // Open the export panel.
            exportSheet.beginSheetModalForWindow(self.window!) { (result: Int) in
                // The user clicked "Export".
                if result == NSFileHandlingPanelOKButton {
                    // Unwrap the file url.
                    guard let url = exportSheet.URL else {
                        return
                    }
                    
                    do {
                        // Save the currently selected asset to the selected file url.
                        try currentView.saveToURL(url)
                        // Open the generated folders in finder.
                        NSWorkspace.sharedWorkspace().openURL(url.URLByAppendingPathComponent("Iconizer Assets", isDirectory: true))
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    ///  Swaps the current ViewController with a new one.
    ///
    ///  - parameter view: Takes a ViewControllerTag.
    func changeView(view: ViewControllerTag?) {
        // Unwrap the current view, if any...
        if let currentView = self.currentView {
            // ...and remove it from the superview.
            currentView.view.removeFromSuperview()
        }
        
        // Check which ViewControllerTag is given. And set self.currentView to
        // the correspondig view.
        if let view = view {
            switch view {
            case .kAppIconViewControllerTag:
                self.currentView = AppIconViewController()
                
            case .kImageSetViewControllerTag:
                self.currentView = ImageSetViewController()
                
            case .kLaunchImageViewControllerTag:
                self.currentView = LaunchImageViewController()
            }
        }
        
        // Add the selected view to the mainView of MainWindow.
        if let currentView = self.currentView {
            self.mainView.addSubview(currentView.view)
            currentView.view.frame = self.mainView.bounds
            currentView.view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        }
    }
}
