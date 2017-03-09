//
// StringExtensions.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

extension String {

    ///  Returns a string object containing the characters between the
    ///  given start and end characters. Excluding the given start and end
    ///  characters.
    ///
    ///  - parameter start: Starting point.
    ///  - parameter end:   End point.
    ///
    ///  - returns: Characters between the given start and end charaters.
    func substringFromCharacter(_ start: String, to end: String) -> String? {
        // Return nil in case either the given start or end string doesn't exist.
        guard let startIndex = self.range(of: start), let endIndex = self.range(of: end) else {
            return nil
        }

        return substring(with: Range(startIndex.upperBound ..< endIndex.lowerBound))
    }
}
