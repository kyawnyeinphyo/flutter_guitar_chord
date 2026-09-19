import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterGuitarChord Widget Tests', () {
    testWidgets('renders basic C major chord diagram and label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              totalString: 6,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlutterGuitarChord),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      expect(find.text('Cmajor'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              showLabel: false,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Cmajor'), findsNothing);
    });

    testWidgets('respects explicit width and height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FlutterGuitarChord(
                width: 180,
                height: 220,
                baseFret: 1,
                chordName: 'Am',
                fingers: '0 0 2 3 1 0',
                frets: '0 0 2 2 1 0',
              ),
            ),
          ),
        ),
      );

      final sizedBoxFinder = find.descendant(
        of: find.byType(FlutterGuitarChord),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsOneWidget);

      final SizedBox sizedBox = tester.widget(sizedBoxFinder);
      expect(sizedBox.width, 180);
      expect(sizedBox.height, 220);
    });

    testWidgets('applies custom chordNameStyle', (WidgetTester tester) async {
      const customStyle = TextStyle(
        fontSize: 22,
        color: Colors.purple,
        fontWeight: FontWeight.w900,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Em',
              fingers: '0 2 3 0 0 0',
              frets: '0 2 2 0 0 0',
              chordNameStyle: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Em'));
      expect(textWidget.style, customStyle);
    });

    testWidgets('renders barre chords properly (e.g. F major, Bm)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Fmajor',
              fingers: '1 3 4 2 1 1',
              frets: '1 3 3 2 1 1',
              totalString: 6,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Fmajor'), findsOneWidget);
    });

    testWidgets('renders 4-string instruments like Ukulele',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'C',
              fingers: '0 0 0 3',
              frets: '0 0 0 3',
              totalString: 4,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('handles whitespace gracefully in frets and fingers',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'G',
              fingers: '  2   1  0  0  0  3  ',
              frets: '  3   2  0  0  0  3  ',
              totalString: 6,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
    });

    testWidgets('renders open strings indicator when labelOpenStrings is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'D',
              fingers: '0 0 0 1 3 2',
              frets: '-1 -1 0 2 3 2',
              labelOpenStrings: true,
              totalString: 6,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
    });

    testWidgets('renders mirrored layout when leftHanded is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              totalString: 6,
              leftHanded: true,
              differentStringStrokes: true,
              labelOpenStrings: true,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Cmajor'), findsOneWidget);
    });

    testWidgets('renders left-handed barre chord properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Fmajor',
              fingers: '1 3 4 2 1 1',
              frets: '1 3 3 2 1 1',
              totalString: 6,
              leftHanded: true,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Fmajor'), findsOneWidget);
    });

    testWidgets('renders in Dark Mode using Theme fallbacks',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          home: const Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Am',
              fingers: '0 0 2 3 1 0',
              frets: '0 0 2 2 1 0',
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Am'), findsOneWidget);
    });

    testWidgets('renders string tuning labels (e.g. E A D G B e)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Cmajor'), findsOneWidget);
    });

    testWidgets('renders capo indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'G',
              fingers: '2 1 0 0 0 3',
              frets: '3 2 0 0 0 3',
              capoFret: 2,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
    });

    testWidgets('renders root note highlight with diamond shape',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              rootString: 1,
              rootColor: Colors.red,
              rootMarkerShape: MarkerShape.diamond,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
    });

    testWidgets('renders in horizontal orientation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'D',
              fingers: '0 0 0 1 3 2',
              frets: '-1 -1 0 2 3 2',
              orientation: ChordOrientation.horizontal,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets(
        'renders without finger numbers when showFingerNumbers is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              showFingerNumbers: false,
            ),
          ),
        ),
      );

      expect(find.byType(FlutterGuitarChord), findsOneWidget);
      expect(find.text('Cmajor'), findsOneWidget);
    });

    testWidgets('contains descriptive Semantics label for accessibility',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              capoFret: 2,
            ),
          ),
        ),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label != null &&
            widget.properties.label!.contains('Cmajor chord') &&
            widget.properties.label!.contains('Capo at fret 2'),
      );
      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('triggers onStringTap and onNoteTap on tapping a note',
        (WidgetTester tester) async {
      int? tappedString;
      int? tappedFret;
      int? playedNoteString;
      int? playedNoteFret;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: FlutterGuitarChord(
                width: 200,
                height: 260,
                baseFret: 1,
                chordName: 'Cmajor',
                fingers: '0 3 2 0 1 0',
                frets: '-1 3 2 0 1 0',
                totalString: 6,
                enableFeedback: false,
                onStringTap: (string, fret) {
                  tappedString = string;
                  tappedFret = fret;
                },
                onNoteTap: (string, fret) {
                  playedNoteString = string;
                  playedNoteFret = fret;
                },
              ),
            ),
          ),
        ),
      );

      // Tap String 1 at Fret 3 (active C note on A string)
      // string 1 x ≈ 30 + 27.8 = 57.8, fret 3 y ≈ 30 + 100 + 25 = 155
      await tester.tapAt(const Offset(58, 155));
      await tester.pump();

      expect(tappedString, equals(1));
      expect(tappedFret, equals(3));
      expect(playedNoteString, equals(1));
      expect(playedNoteFret, equals(3));
    });

    testWidgets('triggers onStringTap but not onNoteTap on unplayed fret',
        (WidgetTester tester) async {
      int? tappedString;
      int? tappedFret;
      int? playedNoteString;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: FlutterGuitarChord(
                width: 200,
                height: 260,
                baseFret: 1,
                chordName: 'Cmajor',
                fingers: '0 3 2 0 1 0',
                frets: '-1 3 2 0 1 0',
                totalString: 6,
                enableFeedback: false,
                onStringTap: (string, fret) {
                  tappedString = string;
                  tappedFret = fret;
                },
                onNoteTap: (string, fret) {
                  playedNoteString = string;
                },
              ),
            ),
          ),
        ),
      );

      // Tap String 1 at Fret 1 (unplayed fret on this string)
      // string 1 x ≈ 57.8, fret 1 y ≈ 55
      await tester.tapAt(const Offset(58, 55));
      await tester.pump();

      expect(tappedString, equals(1));
      expect(tappedFret, equals(1));
      expect(playedNoteString, isNull);
    });

    testWidgets(
        'renders chord label at top when labelPosition is ChordLabelPosition.top',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Gmajor',
              fingers: '2 1 0 0 0 3',
              frets: '3 2 0 0 0 3',
              labelPosition: ChordLabelPosition.top,
              stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
            ),
          ),
        ),
      );

      expect(find.text('Gmajor'), findsOneWidget);
    });

    testWidgets(
        'renders differentStringStrokes with realistic thickness without overflow',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FlutterGuitarChord(
              baseFret: 1,
              chordName: 'Cmajor',
              fingers: '0 3 2 0 1 0',
              frets: '-1 3 2 0 1 0',
              differentStringStrokes: true,
              stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
            ),
          ),
        ),
      );

      expect(find.text('Cmajor'), findsOneWidget);
    });
  });

  group('ChordPainter Unit Tests', () {
    ChordPainter createPainter({
      Color mutedColor = Colors.black,
      bool labelOpenStrings = false,
      bool leftHanded = false,
      double fingerSize = 24,
      int totalString = 6,
    }) {
      return ChordPainter(
        fingerSize: fingerSize,
        totalString: totalString,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: mutedColor,
        labelOpenStrings: labelOpenStrings,
        leftHanded: leftHanded,
      );
    }

    test('shouldRepaint returns false when identical', () {
      final painter1 = createPainter();
      final painter2 = createPainter();
      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('shouldRepaint detects mutedColor change', () {
      final painter1 = createPainter(mutedColor: Colors.red);
      final painter2 = createPainter(mutedColor: Colors.blue);
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint detects labelOpenStrings change', () {
      final painter1 = createPainter(labelOpenStrings: false);
      final painter2 = createPainter(labelOpenStrings: true);
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint detects leftHanded change', () {
      final painter1 = createPainter(leftHanded: false);
      final painter2 = createPainter(leftHanded: true);
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint detects orientation change', () {
      final painter1 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        orientation: ChordOrientation.vertical,
      );
      final painter2 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        orientation: ChordOrientation.horizontal,
      );
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint detects capoFret change', () {
      final painter1 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        capoFret: null,
      );
      final painter2 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        capoFret: 2,
      );
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint detects showFingerNumbers change', () {
      final painter1 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        showFingerNumbers: true,
      );
      final painter2 = ChordPainter(
        fingerSize: 24,
        totalString: 6,
        bar: 4,
        stringStroke: 2,
        differentStringStrokes: false,
        barStroke: 1,
        firstFrameStroke: 4,
        baseFret: 1,
        frets: '-1 3 2 0 1 0',
        fingers: '0 3 2 0 1 0',
        stringColor: Colors.black,
        barColor: Colors.black,
        firstFrameColor: Colors.black,
        tabBackgroundColor: Colors.black,
        tabForegroundColor: Colors.white,
        labelColor: Colors.black,
        mutedColor: Colors.black,
        labelOpenStrings: false,
        showFingerNumbers: false,
      );
      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('throws assertion error when string count does not match totalString',
        () {
      expect(
        () => ChordPainter(
          fingerSize: 24,
          totalString: 6,
          bar: 4,
          stringStroke: 2,
          differentStringStrokes: false,
          barStroke: 1,
          firstFrameStroke: 4,
          baseFret: 1,
          frets: '1 2 3', // 3 instead of 6
          fingers: '0 3 2 0 1 0',
          stringColor: Colors.black,
          barColor: Colors.black,
          firstFrameColor: Colors.black,
          tabBackgroundColor: Colors.black,
          tabForegroundColor: Colors.white,
          labelColor: Colors.black,
          mutedColor: Colors.black,
          labelOpenStrings: false,
        ),
        throwsAssertionError,
      );
    });
  });
}
