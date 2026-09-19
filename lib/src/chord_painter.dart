import 'dart:math';

import 'package:flutter/material.dart';

import 'chord_types.dart';

/// Draw chords using CustomPainter
class ChordPainter extends CustomPainter {
  /// Show the fret number and string
  /// For the Cmajor key: '-1 3 2 0 1 0'
  final String frets;

  /// Show the finger number and fret
  /// For the Cmajor key: '0 3 2 0 1 0'
  final String fingers;

  /// Show the base fret number (starts from 1)
  final int baseFret;

  /// Finger tab size
  final double fingerSize;

  /// Total strings to paint
  final int totalString;

  /// Total bars to paint
  final int bar;

  /// Stroke width of the string
  final double stringStroke;

  /// Draw different string strokes for realistic string gauges
  final bool differentStringStrokes;

  /// Stroke width of the bar
  final double barStroke;

  /// Stroke width of the first frame (nut)
  final double firstFrameStroke;

  /// The color of the strings
  final Color stringColor;

  /// The color of the bars
  final Color barColor;

  /// The color of the first frame (nut)
  final Color firstFrameColor;

  /// The background color of tabs
  final Color tabBackgroundColor;

  /// The foreground color of tabs
  final Color tabForegroundColor;

  /// The color of labels
  final Color labelColor;

  /// The color of the muted labels/strings
  final Color mutedColor;

  /// Label the open strings with 'O'
  final bool labelOpenStrings;

  /// Render chord mirrored horizontally for left-handed players
  final bool leftHanded;

  /// Orientation of the chord diagram (vertical or horizontal)
  final ChordOrientation orientation;

  /// Optional tuning labels per string (e.g. ['E', 'A', 'D', 'G', 'B', 'e'])
  final List<String>? stringLabels;

  /// Optional capo fret number
  final int? capoFret;

  /// Optional color for capo bar
  final Color? capoColor;

  /// Optional string index of the root note (0-indexed)
  final int? rootString;

  /// Optional highlight color for the root note
  final Color? rootColor;

  /// Shape for root note marker
  final MarkerShape rootMarkerShape;

  /// Whether to display finger numbers inside markers
  final bool showFingerNumbers;

  /// Currently highlighted/tapped note: (stringIndex, fret)
  final ({int stringIndex, int fret})? highlightedNote;

  /// Color of the tap highlight ring
  final Color? highlightColor;

  ChordPainter({
    required this.fingerSize,
    required this.totalString,
    required this.bar,
    required this.stringStroke,
    required this.differentStringStrokes,
    required this.barStroke,
    required this.firstFrameStroke,
    required this.baseFret,
    required this.frets,
    required this.fingers,
    required this.stringColor,
    required this.barColor,
    required this.firstFrameColor,
    required this.tabBackgroundColor,
    required this.tabForegroundColor,
    required this.labelColor,
    required this.mutedColor,
    required this.labelOpenStrings,
    this.leftHanded = false,
    this.orientation = ChordOrientation.vertical,
    this.stringLabels,
    this.capoFret,
    this.capoColor,
    this.rootString,
    this.rootColor,
    this.rootMarkerShape = MarkerShape.circle,
    this.showFingerNumbers = true,
    this.highlightedNote,
    this.highlightColor,
  })  : _stringsList = frets.trim().split(RegExp(r'\s+')),
        _fingeringList = fingers.trim().split(RegExp(r'\s+')) {
    assert(
      _stringsList.length == totalString,
      'Frets count (${_stringsList.length}) must match totalString ($totalString)',
    );
    assert(
      _fingeringList.length == totalString,
      'Fingers count (${_fingeringList.length}) must match totalString ($totalString)',
    );
  }

  /// Margin around the chord paint
  final double _margin = 38.0;

  /// Calculated value of string gap
  late double _stringGap;

  /// Calculated value of bar gap
  late double _barGap;

  final List<String> _stringsList, _fingeringList;

  /// Returns the visual column index for a given string index.
  /// For right-handed: 0 is on the left, totalString - 1 on the right.
  /// For left-handed: 0 is on the right, totalString - 1 on the left.
  int _getStringColumn(int stringIndex) {
    return leftHanded ? (totalString - 1 - stringIndex) : stringIndex;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int tGap = totalString - 1;
    if (tGap < 1) tGap = 1;

    final isVertical = orientation == ChordOrientation.vertical;

    if (isVertical) {
      _stringGap =
          ((size.width - _margin * 2) / tGap) - (stringStroke / 2 / tGap);
      _barGap = (size.height - _margin * 2) / bar;
    } else {
      _barGap = (size.width - _margin * 2) / bar;
      _stringGap =
          ((size.height - _margin * 2) / tGap) - (stringStroke / 2 / tGap);
    }

    final paint = Paint();

    // 1. Draw Strings
    for (int i = 0; i < totalString; i++) {
      final col = _getStringColumn(i);
      final isMuted =
          _stringsList[i] == '-1' || _stringsList[i].toLowerCase() == 'x';

      if (differentStringStrokes) {
        final factor =
            1.0 + ((totalString - 1 - i) / max(1, totalString - 1)) * 1.4;
        paint.strokeWidth = stringStroke * factor;
      } else {
        paint.strokeWidth = stringStroke;
      }
      paint.color = isMuted ? mutedColor : stringColor;

      if (isVertical) {
        final x = _margin + (col * _stringGap);
        canvas.drawLine(
          Offset(x, _margin),
          Offset(x, size.height - _margin),
          paint,
        );
      } else {
        final y = _margin + (col * _stringGap);
        canvas.drawLine(
          Offset(_margin, y),
          Offset(size.width - _margin, y),
          paint,
        );
      }
    }

    // 2. Draw Frets / Bars
    for (int i = 0; i <= bar; i++) {
      final isNut = i == 0 && baseFret == 1;
      paint
        ..strokeWidth = isNut ? firstFrameStroke : barStroke
        ..color = isNut ? firstFrameColor : barColor;

      if (isVertical) {
        final y = _margin + (i * _barGap);
        canvas.drawLine(
          Offset(_margin, y),
          Offset(size.width - _margin, y),
          paint,
        );
      } else {
        final x = _margin + (i * _barGap);
        canvas.drawLine(
          Offset(x, _margin),
          Offset(x, size.height - _margin),
          paint,
        );
      }
    }

    // 3. Draw Capo if specified
    if (capoFret != null &&
        capoFret! >= baseFret &&
        capoFret! <= baseFret + bar) {
      final capoIndex = capoFret! - baseFret;
      final capoPaint = Paint()
        ..color = capoColor ?? firstFrameColor
        ..style = PaintingStyle.fill;

      if (isVertical) {
        final y = _margin + (capoIndex * _barGap);
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(_margin - 8, y - 4, size.width - _margin * 2 + 16, 8),
          const Radius.circular(4),
        );
        canvas.drawRRect(rrect, capoPaint);
      } else {
        final x = _margin + (capoIndex * _barGap);
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 4, _margin - 8, 8, size.height - _margin * 2 + 16),
          const Radius.circular(4),
        );
        canvas.drawRRect(rrect, capoPaint);
      }
    }

    int firstBarNumber = 99;
    for (String i in _stringsList) {
      if (i == '-1' || i == '0' || i.toLowerCase() == 'x') continue;
      int? val = int.tryParse(i);
      if (val != null) {
        firstBarNumber = min<int>(firstBarNumber, val);
      }
    }

    // 4. Draw Fret Number Labels
    for (int i = 0; i < bar; i++) {
      int barNumber = baseFret + i;

      final textPainter = TextPainter(
        text: TextSpan(
          text: barNumber.toString(),
          style: TextStyle(
            color: labelColor,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (isVertical) {
        final y = _margin + (i * _barGap) + _barGap / 2;
        final fretX = _margin - (fingerSize / 2) - textPainter.width - 5;
        textPainter.paint(
          canvas,
          Offset(fretX, y - textPainter.height / 2),
        );
      } else {
        final x = _margin + (i * _barGap) + _barGap / 2;
        final fretY = _margin - (fingerSize / 2) - textPainter.height - 5;
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, fretY),
        );
      }
    }

    // 5. Draw Open ('O') and Muted ('X') string indicators
    for (int i = 0; i < totalString; i++) {
      String textToDisplay = '';
      Color textColor = mutedColor;

      if (_stringsList[i] == '-1' || _stringsList[i].toLowerCase() == 'x') {
        textToDisplay = 'X';
        textColor = mutedColor;
      } else if (_stringsList[i] == '0' && labelOpenStrings) {
        textToDisplay = 'O';
        textColor = labelColor;
      } else {
        continue;
      }

      final col = _getStringColumn(i);

      final textPainter = TextPainter(
        text: TextSpan(
          text: textToDisplay,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (isVertical) {
        final x = _margin + (col * _stringGap);
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, _margin - textPainter.height - 4),
        );
      } else {
        final y = _margin + (col * _stringGap);
        textPainter.paint(
          canvas,
          Offset(_margin - textPainter.width - 6, y - textPainter.height / 2),
        );
      }
    }

    // 6. Draw Tuning Labels if provided
    if (stringLabels != null && stringLabels!.isNotEmpty) {
      for (int i = 0; i < totalString && i < stringLabels!.length; i++) {
        final col = _getStringColumn(i);
        final label = stringLabels![i];

        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        if (isVertical) {
          final x = _margin + (col * _stringGap);
          textPainter.paint(
            canvas,
            Offset(x - textPainter.width / 2, size.height - _margin + 4),
          );
        } else {
          final y = _margin + (col * _stringGap);
          textPainter.paint(
            canvas,
            Offset(size.width - _margin + 6, y - textPainter.height / 2),
          );
        }
      }
    }

    // 7. Render Finger Information (Markers & Barre)
    _renderChordInformation(canvas, paint, fingerSize, firstBarNumber);
  }

  /// Render chord information on the canvas
  void _renderChordInformation(
    Canvas canvas,
    Paint paint,
    double fingerSize,
    int firstBarNumber,
  ) {
    Set<String> rendered = {};

    for (int i = 0; i < totalString; i++) {
      int from = i, to = i;
      String currentFinger = _fingeringList[i];

      // check if the string is muted, open, or finger is already rendered
      if (currentFinger == '0' ||
          _stringsList[i] == '-1' ||
          _stringsList[i].toLowerCase() == 'x' ||
          rendered.contains(currentFinger)) {
        continue;
      }

      rendered.add(currentFinger);

      // Search index for another occurrence of the same finger at the same fret (barre)
      for (int i0 = i + 1; i0 < totalString; i0++) {
        if (currentFinger == _fingeringList[i0] &&
            _stringsList[i] == _stringsList[i0]) {
          to = i0;
        }
      }

      int? fretNumber = int.tryParse(_stringsList[i]);
      if (fretNumber == null || fretNumber < 1) continue;

      final isRoot =
          rootString != null && (from == rootString || to == rootString);
      final markerColor =
          isRoot ? (rootColor ?? const Color(0xffe53935)) : tabBackgroundColor;

      final p1 = _getPointOfNote(fretNumber, from);
      final p2 = _getPointOfNote(fretNumber, to);

      final centerPoint = from == to ? p1 : Rect.fromPoints(p1, p2).center;

      if (from != to) {
        // Barre chord line
        canvas.drawLine(
          p1,
          p2,
          paint
            ..strokeWidth = fingerSize
            ..color = markerColor
            ..strokeCap = StrokeCap.round,
        );
      } else {
        // Single note dot
        if (isRoot && rootMarkerShape == MarkerShape.square) {
          final rect = Rect.fromCenter(
            center: centerPoint,
            width: fingerSize,
            height: fingerSize,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(3)),
            paint
              ..color = markerColor
              ..style = PaintingStyle.fill,
          );
        } else if (isRoot && rootMarkerShape == MarkerShape.diamond) {
          final half = fingerSize / 2;
          final path = Path()
            ..moveTo(centerPoint.dx, centerPoint.dy - half)
            ..lineTo(centerPoint.dx + half, centerPoint.dy)
            ..lineTo(centerPoint.dx, centerPoint.dy + half)
            ..lineTo(centerPoint.dx - half, centerPoint.dy)
            ..close();
          canvas.drawPath(
            path,
            paint
              ..color = markerColor
              ..style = PaintingStyle.fill,
          );
        } else {
          canvas.drawLine(
            p1,
            p2,
            paint
              ..strokeWidth = fingerSize
              ..color = markerColor
              ..strokeCap = StrokeCap.round,
          );
        }
      }

      // Draw highlight ring on tapped note if active
      final actualFret = baseFret + (fretNumber - 1);
      final isHighlighted = highlightedNote != null &&
          highlightedNote!.fret == actualFret &&
          highlightedNote!.stringIndex >= min(from, to) &&
          highlightedNote!.stringIndex <= max(from, to);

      if (isHighlighted) {
        final highlightPaint = Paint()
          ..color =
              (highlightColor ?? const Color(0xffffb300)).withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5;
        canvas.drawCircle(centerPoint, fingerSize * 0.8, highlightPaint);
      }

      // Draw finger number if enabled
      if (showFingerNumbers && currentFinger.trim().isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: currentFinger,
            style: TextStyle(
              color: tabForegroundColor,
              fontSize: fingerSize * 0.55,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(
            centerPoint.dx - textPainter.width / 2,
            centerPoint.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  /// Return the calculated position of note on canvas
  Offset _getPointOfNote(
    int barPosition,
    int stringPosition,
  ) {
    barPosition -= 1;

    final col = _getStringColumn(stringPosition);

    if (orientation == ChordOrientation.vertical) {
      final x = _margin + (col * _stringGap);
      final y = _margin + (barPosition * _barGap) + _barGap / 2;
      return Offset(x, y);
    } else {
      final x = _margin + (barPosition * _barGap) + _barGap / 2;
      final y = _margin + (col * _stringGap);
      return Offset(x, y);
    }
  }

  /// Repaint the chord when property changes
  @override
  bool shouldRepaint(covariant ChordPainter old) {
    return old.fingerSize != fingerSize ||
        old.totalString != totalString ||
        old.bar != bar ||
        old.stringStroke != stringStroke ||
        old.differentStringStrokes != differentStringStrokes ||
        old.barStroke != barStroke ||
        old.firstFrameStroke != firstFrameStroke ||
        old.baseFret != baseFret ||
        old.frets != frets ||
        old.fingers != fingers ||
        old.stringColor != stringColor ||
        old.barColor != barColor ||
        old.firstFrameColor != firstFrameColor ||
        old.tabBackgroundColor != tabBackgroundColor ||
        old.tabForegroundColor != tabForegroundColor ||
        old.labelColor != labelColor ||
        old.mutedColor != mutedColor ||
        old.labelOpenStrings != labelOpenStrings ||
        old.leftHanded != leftHanded ||
        old.orientation != orientation ||
        old.stringLabels != stringLabels ||
        old.capoFret != capoFret ||
        old.capoColor != capoColor ||
        old.rootString != rootString ||
        old.rootColor != rootColor ||
        old.rootMarkerShape != rootMarkerShape ||
        old.showFingerNumbers != showFingerNumbers ||
        old.highlightedNote != highlightedNote ||
        old.highlightColor != highlightColor;
  }
}
