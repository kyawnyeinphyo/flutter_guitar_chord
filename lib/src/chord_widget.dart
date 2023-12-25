import 'dart:math';

import 'package:flutter/material.dart';

class FlutterGuitarChord extends StatelessWidget {
  final String frets, fingers, chordName;
  final int baseFret;

  final double margin;
  final double fingerSize;
  final int totalString;
  final int bar;

  final double stringStoke;
  final double barStoke;
  final double firstFrameStoke;

  const FlutterGuitarChord({
    Key? key,
    this.margin = 30,
    this.fingerSize = 25,
    this.totalString = 6,
    this.bar = 4,
    this.stringStoke = 2,
    this.barStoke = 1,
    this.firstFrameStoke = 4,
    required this.fingers,
    required this.frets,
    required this.chordName,
    required this.baseFret,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ChordPainter(
            baseFret: baseFret,
            strings: frets,
            fingering: fingers,
            bar: bar,
            barStoke: barStoke,
            fingerSize: fingerSize,
            firstFrameStoke: firstFrameStoke,
            margin: margin,
            stringStoke: stringStoke,
            totalString: totalString,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            chordName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}

class _ChordPainter extends CustomPainter {
  final String strings, fingering;
  final int baseFret;

  final List<String> stringsList, fingeringList;

  final double margin;
  final double fingerSize;
  final int totalString;
  final int bar;

  final double stringStoke;
  final double barStoke;
  final double firstFrameStoke;

  late double strGap;
  late double barGap;

  _ChordPainter({
    required this.margin,
    required this.fingerSize,
    required this.totalString,
    required this.bar,
    required this.stringStoke,
    required this.barStoke,
    required this.firstFrameStoke,
    required this.baseFret,
    required this.strings,
    required this.fingering,
  })  : stringsList = strings.split(' '),
        fingeringList = fingering.split(' ') {
    assert(stringsList.length == totalString);
    assert(fingeringList.length == totalString);
  }

  Offset getPointOf(
    int barPosition,
    int stringPosition,
  ) {
    barPosition -= 1;

    final x = margin + (stringPosition * strGap);
    final y = margin + (barPosition * barGap) + barGap / 2;

    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    int tGap = totalString - 1;
    strGap = ((size.width - margin * 2) / tGap) - (stringStoke / 2 / tGap);

    barGap = ((size.height - margin * 2) / bar);

    final paint = Paint()..strokeWidth = stringStoke;

    ///strings painter
    for (int i = 0; i < totalString; i++) {
      final x = margin + (i * strGap);
      canvas.drawLine(
          Offset(x, margin),
          Offset(
            x,
            size.height - margin,
          ),
          paint);
    }

    ///bar painter
    for (int i = 0; i <= bar; i++) {
      final y = margin + (i * barGap);
      canvas.drawLine(
        Offset(margin, y),
        Offset(
          size.width - margin,
          y,
        ),
        paint..strokeWidth = i == 0 ? firstFrameStoke : barStoke,
      );
    }

    int firstBarNumber = 99;
    for (String i in stringsList) {
      if (i == '-1' || i == '0') continue;

      firstBarNumber = min<int>(firstBarNumber, int.parse(i));
    }

    ///bar label
    for (int i = 0; i < bar; i++) {
      int barNumber = baseFret + i;
      final y = margin + (i * barGap) + barGap / 2;

      TextPainter(
        text: TextSpan(
          text: barNumber.toString(),
          style: const TextStyle(
            color: Colors.black,
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
          Offset(margin - 26, y - 6),
        );
    }

    ///close string label
    for (int i = 0; i < totalString; i++) {
      if (stringsList[i] != '-1') continue;

      final x = margin + (i * strGap);

      TextPainter(
        text: const TextSpan(
          text: 'X',
          style: TextStyle(
            color: Colors.black,
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
          Offset(x - 4, margin - 22),
        );
    }

    renderChord(canvas, paint, fingerSize, firstBarNumber);
  }

  void renderChord(
    Canvas canvas,
    Paint paint,
    double fingerSize,
    int firstBarNumber,
  ) {
    Set<String> rendered = {};

    for (int i = 0; i < totalString; i++) {
      int from = i, to = i;
      String currentFinger = fingeringList[i];

      //check the string is empty or  check the finger is already render
      if (currentFinger == '0' || rendered.contains(currentFinger)) continue;

      rendered.add(currentFinger);

      for (int i0 = i + 1; i0 < totalString; i0++) {
        //search index for another same finger
        if (currentFinger == fingeringList[i0]) {
          //same finger found at _i index
          to = i0;
        }
      }

      //change to integer
      int fretNumber = int.parse(stringsList[i]);
      // if (baseFret > 1) {
      //   fretNumber -= (firstBarNumber - 1);
      // }

      canvas.drawLine(
        getPointOf(fretNumber, from),
        getPointOf(fretNumber, to),
        paint
          ..strokeWidth = fingerSize
          ..strokeCap = StrokeCap.round,
      );

      Offset textPosition = (from == to
              ? getPointOf(fretNumber, from)
              : Rect.fromPoints(
                  getPointOf(fretNumber, from),
                  getPointOf(fretNumber, to),
                ).center) -
          const Offset(4, 7);

      TextPainter(
        text: TextSpan(
          text: currentFinger,
          style: const TextStyle(
            color: Colors.white,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
