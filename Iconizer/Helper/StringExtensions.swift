//
// StringExtensions.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

extension String {

    /// The substring containing the characters between the supplied start and
    /// the supplied end strings. Excluding both.
    ///
    /// - Parameters:
    ///   - start: The starting point.
    ///   - end: The ending point.
    /// - Returns: The substring from the start to the end string or nil when either string weren't found.
    func substringFrom(start: String, to end: String) -> String? {
        // Return nil in case either the given start or end string doesn't exist.
        guard let startIndex = self.range(of: start), let endIndex = self.range(of: end) else {
            return nil
        }

        return String(self[startIndex.upperBound ..< endIndex.lowerBound])
    }
}
