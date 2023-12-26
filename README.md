# FlutterGuitarChord

Simple and easy to use Flutter Guitar Chord widget using custom painter for guitar chord application

_You can use [guitar_chord_library](https://pub.dev/packages/guitar_chord_library) package for chord data_

## Preview

<img src="https://raw.githubusercontent.com/ygnCybernoob/flutter_guitar_chord/main/preview/preview1.gif" height="500em">
<img src="https://raw.githubusercontent.com/ygnCybernoob/flutter_guitar_chord/main/preview/preview2.gif" height="500em">
<img src="https://raw.githubusercontent.com/ygnCybernoob/flutter_guitar_chord/main/preview/preview2.gif" height="500em">

## Getting Started

To use this plugin, add flutter_guitar_chord as a dependency in your [pubspec.yaml](https://flutter.io/using-packages/) file.

## Pubspec.yaml

```yaml
dependencies:
    flutter_guitar_chord: ^0.0.2
```

## Usage Examples

_You can use [guitar_chord_library](https://pub.dev/packages/guitar_chord_library) package for chord data_

```dart
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

//...//

FlutterGuitarChord(
    baseFret: 1,
    chordName: 'Cmajor',
    fingers: '0 3 2 0 1 0',
    frets: '-1 3 2 0 1 0',
    totalString: 6,
    // labelColor: Colors.teal,
    // tabForegroundColor: Colors.white,
    // tabBackgroundColor: Colors.deepOrange,
    // barColor: Colors.black,
    // stringColor: Colors.red,
),
```

## Note

Pull request are always welcome to contribute, [flutter_guitar_chord](https://github.com/ygnCybernoob/flutter_guitar_chord/) github repo.

## Release notes

See [CHANGELOG](https://github.com/ygnCybernoob/flutter_guitar_chord/blob/main/CHANGELOG.md)
