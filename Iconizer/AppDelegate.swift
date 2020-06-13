//
// AppDelegate.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(_: Notification) {
        let mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)

        self.mainWindowController = mainWindowController
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        
        //Check the main window
        if let mainWindow = sender.mainWindow?.windowController as? MainWindowController {
            
            do {
                // Unwrap the url to the selected image an the currently active view.
                guard let currentView = mainWindow.currentView else { return false }
                // Open the selected image file.
                try currentView.openSelectedImage(NSImage(contentsOf: URL(fileURLWithPath: filename)))
            } catch {
                if let error = error as? String {
                    NSLog(error)
                }
                
                return false
            }
            
            return true
        }
        
        return false
    }
}
