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
}
