//
// AspectMode.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

/// Define how to crop the images to generate.
///
/// - fill: Scales the content to fill the size of the view. Some portion
///         of the content may be clipped to fill the view’s bounds.
/// - fit: Scales the content to fit the size of the view by maintaining
///        the aspect ratio. Any remaining area of the view’s bounds is transparent.
/// - none: Default fallback - equivalent to aspect fill.
enum AspectMode: String {
    case fill
    case fit
    case none
}
