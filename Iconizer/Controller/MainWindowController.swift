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
    let userPrefs = PreferenceManager()

    // Override the windowNibName property.
    override var windowNibName: NSNib.Name {
        return NSNib.Name("MainWindow")
    }

    // MARK: Window delegate

    // Set up the main window to reflect user settings.
    override func windowDidLoad() {
        super.windowDidLoad()

        // Unwrap the window property. I don't even know if window can be nil, but
        // as you know: Everytime we force unwrap something, a kitty dies.
        if let window = self.window {
            // Hide the window title, to get the unified toolbar.
            window.titleVisibility = .hidden
        }
        // Change the content view to the last selected view...
        changeView(ViewControllerTag(rawValue: userPrefs.selectedExportType))
        // ...and set the selectedSegment of NSSegmentedControl to the corresponding value.
        exportType.selectedSegment = userPrefs.selectedExportType
    }

    // Save the user preferences before the application terminates.
    func windowWillClose(_: Notification) {
        userPrefs.selectedExportType = exportType.selectedSegment
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
                } catch {
                    self.displayAlertModal(withMessage: "Oh Snap!",
                                           andText: "This should not have happened.")

                    NSLog("Iconizer Error: \(error)")
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
    /// - Parameter view: The ViewControllerTag of the view to display.
    func changeView(_ view: ViewControllerTag?) {
        // Unwrap the current view, if any...
        if let currentView = self.currentView {
            // ...and remove it from the superview.
            currentView.view.removeFromSuperview()
        }
        // Check which ViewControllerTag is given. And set self.currentView to
        // the correspondig view.
        if let view = view {
            switch view {
            case .appIconViewControllerTag:
                currentView = AppIconViewController()

            case .imageSetViewControllerTag:
                currentView = ImageSetViewController()

            case .launchImageViewControllerTag:
                currentView = LaunchImageViewController()
            case .iMessageViewControllerTag:
                currentView = IMessageViewControlller()
            }
        }

        // Unwrap the selected ViewController and the main window.
        if let currentView = self.currentView, let window = self.window {
            // Resize the main window to fit the selected view.
            // Dont resize the window any more, it causes jumping across space. The
            // Content is set to match all views
            // resizeWindowForContentSize(currentView.view.frame.size)
            // Set the main window's contentView to the selected view.
            window.contentView = currentView.view
        }
    }

    /// Resize the main window to the supplied size.
    ///
    /// - Parameter size: The size to resize to.
    func resizeWindowForContentSize(_ size: NSSize) {
        guard let window = self.window else {
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
