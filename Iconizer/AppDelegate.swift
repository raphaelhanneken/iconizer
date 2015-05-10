//
//  AppDelegate.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Handle the window via MainWindowController
    var mainWindowController: MainWindowController?
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Create a new WindowController instance
        let mainWindowController = MainWindowController()
        
        // Display the associated window on screen
        mainWindowController.showWindow(self)
        
        // Point the instance variable to the created MainWindowController object
        self.mainWindowController = mainWindowController
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

