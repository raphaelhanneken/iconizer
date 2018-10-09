//
// MainWindowController.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

/// Controller for the Main Window.
class MainWindowController: NSWindowController, NSWindowDelegate {

    /// Points to the SegmentedControl, which determines which view is currently selected.
    @IBOutlet weak var exportType: NSSegmentedControl!

    /// Represents the currently selected view.
    var currentView: IconizerViewControllerProtocol?

    /// Access the user's preferences.
    let preferences = PreferenceManager()

    // Override the windowNibName property.
    override var windowNibName: NSNib.Name {
        return "MainWindow"
    }

    // MARK: Window delegate

    // Set up the main window to reflect user settings.
    override func windowDidLoad() {
        super.windowDidLoad()

        if let window = self.window {
            window.titleVisibility = .hidden
        }
        self.changeView(ViewControllerTag(rawValue: self.preferences.selectedExportType))
        exportType.selectedSegment = self.preferences.selectedExportType
    }

    // Save the user preferences before the application terminates.
    func windowWillClose(_: Notification) {
        self.preferences.selectedExportType = exportType.selectedSegment
    }

    // MARK: Actions

    /// Select the appropriate view for the selected segment.
    ///
    /// - Parameter sender: The NSSegmentControle that sent the message.
    @IBAction func selectView(_ sender: NSSegmentedControl) {
        changeView(ViewControllerTag(rawValue: sender.selectedSegment))
    }

    /// Save the image(s) as asset catalog.
    ///
    /// - Parameter sender: NSButton, that sent the action.
    @IBAction func saveDocument(_: NSButton) {
        // Unwrap the export view.
        guard let currentView = self.currentView else {
            return
        }
        // Create an new NSSavePanel...
        let exportSheet = NSSavePanel()
        // ...and present it to the user.
        exportSheet.beginSheetModal(for: window!) { (result: NSApplication.ModalResponse) in
            // The user clicked "Export".
            if result == NSApplication.ModalResponse.OK {
                do {
                    // Unwrap the file url and get rid of the last path component.
                    guard let url = exportSheet.url?.deletingLastPathComponent() else {
                        return
                    }
                    // Generate the required images.
                    try currentView.generateRequiredImages()
                    // Save the generated asset catalog to the selected file URL.
                    try currentView.saveAssetCatalog(named: exportSheet.nameFieldStringValue, toURL: url)
                    // Open the generated asset catalog in Finder.
                    NSWorkspace
                        .shared
                        .open(url.appendingPathComponent("Iconizer Assets", isDirectory: true))
                } catch IconizerViewControllerError.missingImage {
                    self.displayAlertModal(withMessage: "Missing Image",
                                           andText: "You have to provide an image to export.")
                } catch IconizerViewControllerError.missingPlatform {
                    self.displayAlertModal(withMessage: "Missing Platform",
                                           andText: "You have to at least select one platform.")
                } catch ContentsJSONError.fileNotFound {
                    self.displayAlertModal(withMessage: "File not Found",
                                           andText: "The JSON file for generating the necessary images is missing.")
                } catch {
                    self.displayAlertModal(withMessage: "Oh Snap!",
                                           andText: "This should not have happened.")
                }
            }
        }
    }

    /// Save the image(s) as asset catalog.
    ///
    /// - Parameter sender: NSButton that sent the action.
    @IBAction func saveDocumentAs(_ sender: NSButton) {
        saveDocument(sender)
    }

    /// Present an open dialog to the user.
    ///
    /// - Parameter sender: NSButton that sent the action.
    @IBAction func openDocument(_: NSButton) {
        // Create a new NSOpenPanel instance.
        let openPanel = NSOpenPanel()
        // Configure the NSOpenPanel
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        // Present the open panel to the user and get the selected file.
        let response = openPanel.runModal()
        if response == NSApplication.ModalResponse.OK {
            do {
                // Unwrap the url to the selected image an the currently active view.
                guard let url = openPanel.url, let currentView = self.currentView else {
                    return
                }
                // Open the selected image file.
                try currentView.openSelectedImage(NSImage(contentsOf: url))
            } catch {
                if let error = error as? String {
                    NSLog(error)
                }
                return
            }
        }
    }

    // MARK: Changing Views

    /// Swap the current view with a new one.
    ///
    /// - Parameter newView: The ViewControllerTag of the view to display.
    func changeView(_ newView: ViewControllerTag?) {
        guard let window = self.window,
            let newView  = newView else {
                return
        }

        switch newView {
        case .appIconViewControllerTag:
            self.currentView = AppIconViewController()
        case .imageSetViewControllerTag:
            self.currentView = ImageSetViewController()
        case .launchImageViewControllerTag:
            self.currentView = LaunchImageViewController()
        }

        resizeWindowForContentSize(self.currentView?.view.frame.size)
        window.contentView = self.currentView?.view
    }

    /// Resize the main window to the supplied size.
    ///
    /// - Parameter size: The size to resize to.
    func resizeWindowForContentSize(_ size: NSSize?) {
        guard let window = self.window, let size = size else {
            return
        }

        let windowContentRect = window.contentRect(forFrameRect: window.frame)
        let newContentRect = NSRect(x: windowContentRect.minX,
                                    y: windowContentRect.maxY - size.height,
                                    width: size.width,
                                    height: size.height)

        window.setFrame(window.frameRect(forContentRect: newContentRect),
                        display: true,
                        animate: true)
    }

    // MARK: - Private Methods

    /// Display an alert modal.
    ///
    /// - Parameters:
    ///   - msg: The alerts message text.
    ///   - txt: The alerts informative text.
    private func displayAlertModal(withMessage msg: String, andText txt: String) {
        let alert = NSAlert()
        alert.messageText = msg
        alert.informativeText = txt
        alert.beginSheetModal(for: window!, completionHandler: nil)
    }
}
