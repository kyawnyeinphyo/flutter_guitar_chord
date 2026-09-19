# CHANGELOG

## 0.1.0

* Modernized SDK constraints to Dart `^3.3.0` and Flutter `>=3.19.0`.
* Upgraded to `flutter_lints` ^5.0.0 and modern Dart 3 best practices.
* Added automatic Dark Mode & Theme adaptation (`Theme.of(context)` fallbacks).
* Added `leftHanded` support to render mirrored chord diagrams for left-handed players (#5).
* Added `orientation` support for both vertical and horizontal fretboard layouts (`ChordOrientation`).
* Added `stringLabels` to display tuning notes (e.g. `E A D G B e`) along strings.
* Added `capoFret` and `capoColor` for visual capo clamp indicators.
* Added `rootString`, `rootColor`, and `rootMarkerShape` (`circle`, `square`, `diamond`) for root note highlighting.
* Added `showFingerNumbers` toggle to support minimalist solid dot markers.
* Added `labelPosition` (`ChordLabelPosition.top` | `ChordLabelPosition.bottom`) with overflow-proof layout preventing overlaps with tuning string labels.
* Refined string thickness gradient (`differentStringStrokes`) from harsh linear multipliers to a natural, subtle gauge variation.
* Added interactive chord touch support with `onNoteTap` and `onStringTap` callbacks and animated visual highlight feedback.
* Added `Semantics` accessibility wrapper for screen-reader support.
* Added optional `width` and `height` parameters with responsive `LayoutBuilder` sizing (removes direct `MediaQuery` dependency).
* Added `chordNameStyle` parameter for customizable chord name typography.
* Fixed `shouldRepaint` in `ChordPainter` to properly detect `mutedColor` and `labelOpenStrings` updates.
* Fixed text layout and centering for finger numbers and multi-digit fret numbers.
* Improved barre chord rendering safety so only notes on the same fret are barred together.
* Added `.pubignore` to drastically reduce package archive size from 10MB to ~18KB.
* Added comprehensive unit and widget test suites (29 passing tests).
* Completely redesigned example showcase app featuring an Interactive Playground, full Chord Explorer (`guitar_chord_library ^0.1.0`), and Feature Gallery.

## 0.0.3

* Added optional string size spectrum for better visualization of string thickness
* Added option to display open string “O”
* Added ability to customize mutated string color
* Added option to adjust first fret size

## 0.0.2

* First release

## 0.0.1

* Internal build
