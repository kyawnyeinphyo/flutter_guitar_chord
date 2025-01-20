import 'dart:math';

import 'package:flutter/material.dart';

/// Draw chords using CustomPainter
class ChordPainter extends CustomPainter {
  /// show the fret number and string
  /// for the Cmajor key
  /// -1 3 2 0 1 0
  final String frets;

  /// show the finger number and fret
  /// for the Cmajor key
  ///  0 3 2 0 1 0
  final String fingers;

  /// show the base fret number
  /// start from 1
  /// for the Cmajor key
  /// 1
  final int baseFret;

  /// Finger tab size
  final double fingerSize;

  /// Total strings to paint
  final int totalString;

  /// Total bars to paint
  final int bar;

  /// Stroke width of the string
  final double stringStroke;

  /// Draw different string strokes?
  final bool differentStringStrokes;

  /// Stroke width of the bar
  final double barStroke;

  /// Stroke width of the first frame
  final double firstFrameStroke;

  /// The color of the strings
  final Color stringColor;

  /// The color of the bars
  final Color barColor;

  /// The background color of tabs
  final Color tabBackgroundColor;

  /// The foreground color of tabs
  final Color tabForegroundColor;

  /// The color of labels
  final Color labelColor;

  /// fingers and frets must be same with totalString
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
    required this.tabBackgroundColor,
    required this.tabForegroundColor,
    required this.labelColor,
  })  : _stringsList = frets.split(' '),
        _fingeringList = fingers.split(' ') {
    assert(_stringsList.length == totalString);
    assert(_fingeringList.length == totalString);
  }

  /// Margin aroud the chord paint
  final double _margin = 30;

  /// Calaculated value of string gap
  late double _stringGap;

  /// Calculated value of bar gap
  late double _barGap;

  final List<String> _stringsList, _fingeringList;

  /// This function paint the chord
  @override
  void paint(Canvas canvas, Size size) {
    int tGap = totalString - 1;
    _stringGap =
        ((size.width - _margin * 2) / tGap) - (stringStroke / 2 / tGap);

    _barGap = ((size.height - _margin * 2) / bar);

    final paint = Paint()..strokeWidth = stringStroke;

    ///strings painter
    for (int i = 0; i < totalString; i++) {
      final x = _margin + (i * _stringGap);
      canvas.drawLine(
        Offset(x, _margin),
        Offset(
          x,
          size.height - _margin,
        ),
        paint..color = stringColor,
      );
      if (differentStringStrokes) {
        paint..strokeWidth = paint.strokeWidth - (stringStroke / totalString);
      }
    }

    ///bar painter
    for (int i = 0; i <= bar; i++) {
      final y = _margin + (i * _barGap);
      canvas.drawLine(
        Offset(_margin, y),
        Offset(
          size.width - _margin,
          y,
        ),
        paint
          ..strokeWidth = i == 0 ? firstFrameStroke : barStroke
          ..color = barColor,
      );
    }

    int firstBarNumber = 99;
    for (String i in _stringsList) {
      if (i == '-1' || i == '0') continue;

      firstBarNumber = min<int>(firstBarNumber, int.parse(i));
    }

    ///bar label
    for (int i = 0; i < bar; i++) {
      int barNumber = baseFret + i;
      final y = _margin + (i * _barGap) + _barGap / 2;

      TextPainter(
        text: TextSpan(
          text: barNumber.toString(),
          style: TextStyle(
            color: labelColor,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(maxWidth: 16, minWidth: 4)
        ..paint(
          canvas,
          Offset(_margin - 26, y - 6),
        );
    }

    ///close string label
    for (int i = 0; i < totalString; i++) {
      if (_stringsList[i] != '-1') continue;

      final x = _margin + (i * _stringGap);

      TextPainter(
        text: TextSpan(
          text: 'X',
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(maxWidth: 4, minWidth: 4)
        ..paint(
          canvas,
          Offset(x - 4, _margin - 22),
        );
    }

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

      //check the string is empty or  check the finger is already render
      if (currentFinger == '0' || rendered.contains(currentFinger)) continue;

      rendered.add(currentFinger);

      for (int i0 = i + 1; i0 < totalString; i0++) {
        //search index for another same finger
        if (currentFinger == _fingeringList[i0]) {
          //same finger found at _i index
          to = i0;
        }
      }

      //change to integer
      int fretNumber = int.parse(_stringsList[i]);

      canvas.drawLine(
        _getPointOfNote(fretNumber, from),
        _getPointOfNote(fretNumber, to),
        paint
          ..strokeWidth = fingerSize
          ..color = tabBackgroundColor
          ..strokeCap = StrokeCap.round,
      );

      Offset textPosition = (from == to
              ? _getPointOfNote(fretNumber, from)
              : Rect.fromPoints(
                  _getPointOfNote(fretNumber, from),
                  _getPointOfNote(fretNumber, to),
                ).center) -
          const Offset(4, 7);

      TextPainter(
        text: TextSpan(
          text: currentFinger,
          style: TextStyle(
            color: tabForegroundColor,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout(maxWidth: 4, minWidth: 4)
        ..paint(
          canvas,
          textPosition,
        );
    }
  }

  /// Return the calculated position of note on canvas
  Offset _getPointOfNote(
    int barPosition,
    int stringPosition,
  ) {
    barPosition -= 1;

    final x = _margin + (stringPosition * _stringGap);
    final y = _margin + (barPosition * _barGap) + _barGap / 2;

    return Offset(x, y);
  }

  /// Repaint the chord when property change
  @override
  bool shouldRepaint(covariant ChordPainter old) {
    return old.fingerSize != fingerSize ||
        old.totalString != totalString ||
        old.bar != bar ||
        old.stringStroke != stringStroke ||
        old.barStroke != barStroke ||
        old.firstFrameStroke != firstFrameStroke ||
        old.baseFret != baseFret ||
        old.frets != frets ||
        old.fingers != fingers ||
        old.stringColor != stringColor ||
        old.barColor != barColor ||
        old.tabBackgroundColor != tabBackgroundColor ||
        old.tabForegroundColor != tabForegroundColor ||
        old.labelColor != labelColor;
  }
}
