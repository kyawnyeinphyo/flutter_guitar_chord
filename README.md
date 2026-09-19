# Flutter Guitar Chord

[![Pub Version](https://img.shields.io/pub/v/flutter_guitar_chord.svg)](https://pub.dev/packages/flutter_guitar_chord)
[![Pub Points](https://img.shields.io/pub/points/flutter_guitar_chord.svg)](https://pub.dev/packages/flutter_guitar_chord)
[![Pub Popularity](https://img.shields.io/pub/popularity/flutter_guitar_chord.svg)](https://pub.dev/packages/flutter_guitar_chord)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A simple, lightweight, and customizable Flutter Guitar Chord widget using `CustomPainter` to render beautiful guitar and ukulele chord diagrams.

_Tip: You can pair this package with [guitar_chord_library](https://pub.dev/packages/guitar_chord_library) for rich chord fingering databases!_

---

## Previews

<p align="center">
  <img src="https://raw.githubusercontent.com/kyawnyeinphyo/flutter_guitar_chord/main/preview/playground.png" width="31%" alt="Interactive Playground" />
  &nbsp;
  <img src="https://raw.githubusercontent.com/kyawnyeinphyo/flutter_guitar_chord/main/preview/explorer.png" width="31%" alt="Chord Explorer" />
  &nbsp;
  <img src="https://raw.githubusercontent.com/kyawnyeinphyo/flutter_guitar_chord/main/preview/gallery.png" width="31%" alt="Feature Gallery" />
</p>

<p align="center">
  <em>Interactive Playground &bull; Chord Explorer (guitar_chord_library) &bull; Left-Handed & Horizontal Gallery</em>
</p>

---

## Installation

Add `flutter_guitar_chord` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_guitar_chord: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## Usage Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

// Basic usage
FlutterGuitarChord(
  baseFret: 1,
  chordName: 'Cmajor',
  fingers: '0 3 2 0 1 0',
  frets: '-1 3 2 0 1 0',
  totalString: 6,
)

// Fully customized
FlutterGuitarChord(
  width: 180,
  height: 240,
  baseFret: 1,
  chordName: 'Cmajor',
  fingers: '0 3 2 0 1 0',
  frets: '-1 3 2 0 1 0',
  totalString: 6,
  labelColor: Colors.deepPurple,
  tabForegroundColor: Colors.white,
  tabBackgroundColor: Colors.deepPurple,
  barColor: Colors.grey,
  stringColor: Colors.black87,
  labelOpenStrings: true,
  chordNameStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  ),
)
```

---

## Properties Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `chordName` | `String` | **required** | The name of the chord (e.g. `'Cmajor'`, `'F#m7'`). |
| `frets` | `String` | **required** | Fret position per string, space-delimited (`'-1 3 2 0 1 0'`). Use `-1` or `x` for muted. |
| `fingers` | `String` | **required** | Finger indicator per string, space-delimited (`'0 3 2 0 1 0'`). `0` for open/muted. |
| `baseFret` | `int` | **required** | Starting fret number (typically `1`). |
| `width` | `double?` | `null` | Optional fixed width. Automatically adapts to layout constraints if omitted. |
| `height` | `double?` | `null` | Optional fixed height. Automatically adapts to layout constraints if omitted. |
| `totalString` | `int` | `6` | Number of strings (`6` for guitar, `4` for ukulele/bass). |
| `barCount` | `int` | `4` | Number of frets to display. |
| `fingerSize` | `double` | `24` | Diameter of finger marker dots. |
| `stringStroke` | `double` | `2` | Stroke width of strings. |
| `differentStringStrokes`| `bool` | `false` | When `true`, strings have progressively thicker strokes. |
| `barStroke` | `double` | `1` | Stroke width of fret bars. |
| `firstFrameStroke` | `double` | `4` | Stroke width of top nut (when `baseFret == 1`). |
| `stringColor` | `Color?` | `Theme.onSurface` | Color of playable strings (adapts automatically to Dark Mode). |
| `mutedColor` | `Color?` | `Theme.onSurface` | Color for muted string indicators (`'X'`). |
| `barColor` | `Color?` | `Theme.onSurface` | Color of fret bars. |
| `firstFrameColor` | `Color?` | `Theme.onSurface` | Color of the top nut frame. |
| `tabBackgroundColor` | `Color?` | `Theme.primary` | Background color of finger markers. |
| `tabForegroundColor` | `Color?` | `Theme.onPrimary` | Foreground color of finger marker numbers. |
| `labelColor` | `Color?` | `Theme.onSurface` | Color of bar numbers and chord labels. |
| `showLabel` | `bool` | `true` | Whether to display the chord name text. |
| `labelPosition` | `ChordLabelPosition` | `.bottom` | Placement of the chord name: `ChordLabelPosition.top` or `ChordLabelPosition.bottom`. |
| `chordNameStyle` | `TextStyle?` | `null` | Optional custom text style for the chord name. |
| `labelOpenStrings` | `bool` | `false` | When `true`, draws an `'O'` above open strings. |
| `leftHanded` | `bool` | `false` | When `true`, horizontally mirrors the diagram for left-handed players. |
| `orientation` | `ChordOrientation` | `.vertical` | Fretboard orientation: `ChordOrientation.vertical` or `ChordOrientation.horizontal`. |
| `stringLabels` | `List<String>?` | `null` | Optional tuning notes per string (e.g. `['E', 'A', 'D', 'G', 'B', 'e']`). |
| `capoFret` | `int?` | `null` | Fret number where a capo is attached. |
| `capoColor` | `Color?` | `Theme.secondary` | Color for the capo clamp bar. |
| `rootString` | `int?` | `null` | 0-indexed string of the root note to highlight. |
| `rootColor` | `Color?` | `Colors.redAccent`| Highlight color for the root note marker. |
| `rootMarkerShape` | `MarkerShape` | `.circle` | Shape for root note: `MarkerShape.circle`, `.square`, or `.diamond`. |
| `showFingerNumbers`| `bool` | `true` | When `false`, displays solid dots without finger numbers. |
| `onNoteTap` | `Function(int string, int fret)?` | `null` | Callback triggered when a played note in the chord is tapped. |
| `onStringTap` | `Function(int string, int fret)?` | `null` | Callback triggered when any string/fret coordinate is tapped. |
| `enableFeedback` | `bool` | `true` | Enables subtle haptic feedback on note tap. |
| `highlightColor` | `Color?` | `Colors.amber` | Color for the temporary highlight ring on tap. |

---

## Contributing

Pull requests are always welcome! Feel free to report issues or suggest improvements on the [GitHub Repository](https://github.com/kyawnyeinphyo/flutter_guitar_chord).

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
