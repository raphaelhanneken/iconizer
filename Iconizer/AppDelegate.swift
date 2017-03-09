//
// AppDelegate.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// Handle the window via MainWindowController
    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(_: Notification) {
        // Create a new WindowController instance
        let mainWindowController = MainWindowController()
        // Display the associated window on screen
        mainWindowController.showWindow(self)
        // Point the instance variable to the created MainWindowController object
        self.mainWindowController = mainWindowController
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }
}
