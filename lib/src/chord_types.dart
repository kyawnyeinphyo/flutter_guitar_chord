/// Fretboard orientation for rendering chord diagrams.
enum ChordOrientation {
  /// Vertical orientation (nut at top, strings run vertically).
  vertical,

  /// Horizontal orientation (nut on left, strings run horizontally).
  horizontal,
}

/// Marker shape for finger or root note dots.
enum MarkerShape {
  /// Standard circular marker.
  circle,

  /// Square marker.
  square,

  /// Diamond marker.
  diamond,
}

/// Position for rendering the chord name label.
enum ChordLabelPosition {
  /// Renders chord name above the fretboard diagram.
  top,

  /// Renders chord name below the fretboard diagram.
  bottom,
}
