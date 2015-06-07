//
// ExportTypeController.swift
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

///  Base class for the export types. Provides methods for generating and saving asset catalogs.
///  This class only exist, to call generateRequiredImages() and saveToURL(_:) from the MainWindowController
///  Since NSViewController doesn't provide these methods, we get a compiler error when defining 'var currentView'
///  as NSViewController.
class ExportTypeController: NSViewController {
    ///  Base method for generating the required images.
    ///  Needs to be overridden by subclasses!
    ///
    ///  :returns: returns always false.
    func generateRequiredImages() -> Bool {
        return false
    }
    
    ///  Base method for saving the currently selected asset catalog.
    ///  Needs to be overridden by subclasses!
    ///
    ///  :param: url File path to the directory to save the asset to.
    func saveToURL(url: NSURL) {
        
    }
}
