import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chord_painter.dart';
import 'chord_types.dart';

/// Highly customizable and interactive Flutter Guitar & Ukulele Chord widget using CustomPainter.
class FlutterGuitarChord extends StatefulWidget {
  /// Show the fret number and string
  /// For the Cmajor key: '-1 3 2 0 1 0'
  final String frets;

  /// Show the finger number and fret
  /// For the Cmajor key: '0 3 2 0 1 0'
  final String fingers;

  /// Show the base fret number (starts from 1)
  final int baseFret;

  /// Name of the chord (e.g. 'Cmajor', 'Cm7')
  final String chordName;

  /// Finger tab size on fret
  final double fingerSize;

  /// The total strings count of instrument (e.g. 6 for guitar, 4 for ukulele)
  final int totalString;

  /// The total bars/frets to display
  final int barCount;

  /// The stroke width of the strings
  final double stringStroke;

  /// Different string strokes for progressive string thickness
  final bool differentStringStrokes;

  /// The stroke width of the bars
  final double barStroke;

  /// The stroke width of the first frame (nut)
  final double firstFrameStroke;

  /// The color of the strings (defaults to theme `colorScheme.onSurface`)
  final Color? stringColor;

  /// The color of the bars (defaults to theme `colorScheme.onSurface`)
  final Color? barColor;

  /// The color of the first frame (defaults to theme `colorScheme.onSurface`)
  final Color? firstFrameColor;

  /// The background color of tabs (defaults to theme `colorScheme.primary` or `onSurface`)
  final Color? tabBackgroundColor;

  /// The foreground color of tabs (defaults to theme `colorScheme.onPrimary` or `surface`)
  final Color? tabForegroundColor;

  /// The color of labels (defaults to theme `colorScheme.onSurface`)
  final Color? labelColor;

  /// The color of muted string markers (defaults to theme `colorScheme.onSurface`)
  final Color? mutedColor;

  /// Status to show chord name label
  final bool showLabel;

  /// Status to show open strings label 'O'
  final bool labelOpenStrings;

  /// Render chord mirrored horizontally for left-handed players
  final bool leftHanded;

  /// Fretboard orientation (vertical or horizontal)
  final ChordOrientation orientation;

  /// Optional tuning labels for each string (e.g. `['E', 'A', 'D', 'G', 'B', 'e']`)
  final List<String>? stringLabels;

  /// Optional capo fret number
  final int? capoFret;

  /// Optional color for capo bar
  final Color? capoColor;

  /// Optional string index of the root note to highlight (0-indexed)
  final int? rootString;

  /// Optional highlight color for the root note
  final Color? rootColor;

  /// Shape for root note marker
  final MarkerShape rootMarkerShape;

  /// Whether to display finger numbers inside dots
  final bool showFingerNumbers;

  /// Optional fixed width for the chord widget
  final double? width;

  /// Optional fixed height for the chord widget
  final double? height;

  /// Position of the chord name label (top or bottom)
  final ChordLabelPosition labelPosition;

  /// Optional text style for the chord name label
  final TextStyle? chordNameStyle;

  /// Callback triggered when any string and fret position is tapped
  final void Function(int stringIndex, int fret)? onStringTap;

  /// Callback triggered only when a played note in the chord (or open string) is tapped
  final void Function(int stringIndex, int fret)? onNoteTap;

  /// Whether to provide haptic feedback when tapping notes
  final bool enableFeedback;

  /// Color used for the temporary highlight ring when a note is tapped
  final Color? highlightColor;

  const FlutterGuitarChord({
    super.key,
    required this.fingers,
    required this.frets,
    required this.baseFret,
    required this.chordName,
    this.totalString = 6,
    this.fingerSize = 24,
    this.barCount = 4,
    this.stringStroke = 2,
    this.differentStringStrokes = false,
    this.barStroke = 1,
    this.firstFrameStroke = 4,
    this.stringColor,
    this.barColor,
    this.firstFrameColor,
    this.tabBackgroundColor,
    this.tabForegroundColor,
    this.labelColor,
    this.mutedColor,
    this.showLabel = true,
    this.labelPosition = ChordLabelPosition.bottom,
    this.labelOpenStrings = false,
    this.leftHanded = false,
    this.orientation = ChordOrientation.vertical,
    this.stringLabels,
    this.capoFret,
    this.capoColor,
    this.rootString,
    this.rootColor,
    this.rootMarkerShape = MarkerShape.circle,
    this.showFingerNumbers = true,
    this.width,
    this.height,
    this.chordNameStyle,
    this.onStringTap,
    this.onNoteTap,
    this.enableFeedback = true,
    this.highlightColor,
  });

  @override
  State<FlutterGuitarChord> createState() => _FlutterGuitarChordState();
}

class _FlutterGuitarChordState extends State<FlutterGuitarChord> {
  ({int stringIndex, int fret})? _highlightedNote;
  Timer? _highlightTimer;

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  void _triggerHighlight(int stringIndex, int fret) {
    _highlightTimer?.cancel();
    setState(() {
      _highlightedNote = (stringIndex: stringIndex, fret: fret);
    });
    _highlightTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _highlightedNote = null;
        });
      }
    });
  }

  void _handleTap(Offset localPosition, double width, double height) {
    if (widget.onStringTap == null && widget.onNoteTap == null) return;

    final isVertical = widget.orientation == ChordOrientation.vertical;
    const margin = 38.0;
    final tGap = widget.totalString - 1 < 1 ? 1 : widget.totalString - 1;
    final barCount = widget.barCount < 1 ? 1 : widget.barCount;

    double stringGap;
    double barGap;

    if (isVertical) {
      stringGap =
          ((width - margin * 2) / tGap) - (widget.stringStroke / 2 / tGap);
      barGap = (height - margin * 2) / barCount;
    } else {
      barGap = (width - margin * 2) / barCount;
      stringGap =
          ((height - margin * 2) / tGap) - (widget.stringStroke / 2 / tGap);
    }

    int? detectedCol;
    int? detectedFret;

    if (isVertical) {
      final relativeX = localPosition.dx - margin;
      final col = (relativeX / stringGap).round();
      if (col >= 0 && col < widget.totalString) {
        final expectedX = margin + col * stringGap;
        if ((localPosition.dx - expectedX).abs() <= stringGap * 0.7) {
          detectedCol = col;
        }
      }

      if (localPosition.dy < margin) {
        detectedFret = 0; // open or muted header area
      } else if (localPosition.dy >= margin &&
          localPosition.dy <= height - margin) {
        final fretSlot = ((localPosition.dy - margin) / barGap).floor();
        if (fretSlot >= 0 && fretSlot < barCount) {
          detectedFret = widget.baseFret + fretSlot;
        }
      }
    } else {
      final relativeY = localPosition.dy - margin;
      final col = (relativeY / stringGap).round();
      if (col >= 0 && col < widget.totalString) {
        final expectedY = margin + col * stringGap;
        if ((localPosition.dy - expectedY).abs() <= stringGap * 0.7) {
          detectedCol = col;
        }
      }

      if (localPosition.dx < margin) {
        detectedFret = 0; // open or muted header area on left
      } else if (localPosition.dx >= margin &&
          localPosition.dx <= width - margin) {
        final fretSlot = ((localPosition.dx - margin) / barGap).floor();
        if (fretSlot >= 0 && fretSlot < barCount) {
          detectedFret = widget.baseFret + fretSlot;
        }
      }
    }

    if (detectedCol == null || detectedFret == null) return;

    final stringIndex = widget.leftHanded
        ? (widget.totalString - 1 - detectedCol)
        : detectedCol;

    // Trigger general onStringTap
    widget.onStringTap?.call(stringIndex, detectedFret);

    // Check if the tapped coordinate corresponds to an active note in the chord
    final fretsList = widget.frets.trim().split(RegExp(r'\s+'));
    if (stringIndex < fretsList.length) {
      final fretVal = fretsList[stringIndex];
      bool isPlayedNote = false;

      if (detectedFret == 0 && fretVal == '0') {
        isPlayedNote = true;
      } else if (fretVal != '-1' && fretVal.toLowerCase() != 'x') {
        final relativeFret = int.tryParse(fretVal);
        if (relativeFret != null) {
          final actualFret = widget.baseFret + (relativeFret - 1);
          if (detectedFret == actualFret) {
            isPlayedNote = true;
          }
        }
      }

      if (isPlayedNote) {
        if (widget.enableFeedback) {
          HapticFeedback.lightImpact();
        }
        _triggerHighlight(stringIndex, detectedFret);
        widget.onNoteTap?.call(stringIndex, detectedFret);
      }
    }
  }

  String _buildSemanticsLabel() {
    final buffer = StringBuffer(
        '${widget.chordName} chord, base fret ${widget.baseFret}.');
    if (widget.capoFret != null) {
      buffer.write(' Capo at fret ${widget.capoFret}.');
    }
    if (widget.leftHanded) {
      buffer.write(' Left-handed.');
    }

    final fretTokens = widget.frets.trim().split(RegExp(r'\s+'));
    if (fretTokens.isNotEmpty) {
      buffer.write(' Strings: ');
      final List<String> descriptions = [];
      for (int i = 0; i < fretTokens.length; i++) {
        final token = fretTokens[i];
        if (token == '-1' || token.toLowerCase() == 'x') {
          descriptions.add('string ${i + 1} muted');
        } else if (token == '0') {
          descriptions.add('string ${i + 1} open');
        } else {
          descriptions.add('string ${i + 1} fret $token');
        }
      }
      buffer.write(descriptions.join(', '));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Automatic dark mode & theme adaptation fallbacks
    final effectiveStringColor = widget.stringColor ?? colorScheme.onSurface;
    final effectiveBarColor =
        widget.barColor ?? colorScheme.onSurface.withValues(alpha: 0.7);
    final effectiveFirstFrameColor =
        widget.firstFrameColor ?? colorScheme.onSurface;
    final effectiveTabBg = widget.tabBackgroundColor ?? colorScheme.primary;
    final effectiveTabFg = widget.tabForegroundColor ?? colorScheme.onPrimary;
    final effectiveLabelColor = widget.labelColor ?? colorScheme.onSurface;
    final effectiveMutedColor =
        widget.mutedColor ?? colorScheme.onSurface.withValues(alpha: 0.8);
    final effectiveCapoColor = widget.capoColor ?? colorScheme.secondary;
    final effectiveRootColor = widget.rootColor ?? Colors.redAccent;

    final isVertical = widget.orientation == ChordOrientation.vertical;
    final defaultW = isVertical ? 200.0 : 260.0;
    final defaultH = isVertical ? 260.0 : 200.0;

    return Semantics(
      label: _buildSemanticsLabel(),
      image: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double w = widget.width ??
              (constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : defaultW);
          final hasBoundedH = widget.height != null ||
              (constraints.hasBoundedHeight && constraints.maxHeight.isFinite);
          final double h =
              widget.height ?? (hasBoundedH ? constraints.maxHeight : defaultH);

          Widget buildCanvasBody(double canvasW, double canvasH) {
            final chordPainterWidget = CustomPaint(
              size: Size(canvasW, canvasH),
              painter: ChordPainter(
                baseFret: widget.baseFret,
                frets: widget.frets,
                fingers: widget.fingers,
                bar: widget.barCount,
                barStroke: widget.barStroke,
                fingerSize: widget.fingerSize,
                firstFrameStroke: widget.firstFrameStroke,
                stringStroke: widget.stringStroke,
                differentStringStrokes: widget.differentStringStrokes,
                totalString: widget.totalString,
                barColor: effectiveBarColor,
                firstFrameColor: effectiveFirstFrameColor,
                labelColor: effectiveLabelColor,
                mutedColor: effectiveMutedColor,
                stringColor: effectiveStringColor,
                tabBackgroundColor: effectiveTabBg,
                tabForegroundColor: effectiveTabFg,
                labelOpenStrings: widget.labelOpenStrings,
                leftHanded: widget.leftHanded,
                orientation: widget.orientation,
                stringLabels: widget.stringLabels,
                capoFret: widget.capoFret,
                capoColor: effectiveCapoColor,
                rootString: widget.rootString,
                rootColor: effectiveRootColor,
                rootMarkerShape: widget.rootMarkerShape,
                showFingerNumbers: widget.showFingerNumbers,
                highlightedNote: _highlightedNote,
                highlightColor: widget.highlightColor,
              ),
            );

            return (widget.onStringTap != null || widget.onNoteTap != null)
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) =>
                        _handleTap(details.localPosition, canvasW, canvasH),
                    child: chordPainterWidget,
                  )
                : chordPainterWidget;
          }

          final labelWidget = widget.showLabel
              ? Padding(
                  padding: EdgeInsets.only(
                    top: widget.labelPosition == ChordLabelPosition.bottom
                        ? 4.0
                        : 0.0,
                    bottom: widget.labelPosition == ChordLabelPosition.top
                        ? 4.0
                        : 0.0,
                  ),
                  child: Text(
                    widget.chordName,
                    style: widget.chordNameStyle ??
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: effectiveLabelColor,
                        ),
                  ),
                )
              : null;

          if (hasBoundedH) {
            return SizedBox(
              width: w,
              height: h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.labelPosition == ChordLabelPosition.top &&
                      labelWidget != null)
                    labelWidget,
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final cw = box.maxWidth.isFinite && box.maxWidth > 0
                            ? box.maxWidth
                            : w;
                        final ch = box.maxHeight.isFinite && box.maxHeight > 0
                            ? box.maxHeight
                            : defaultH;
                        return buildCanvasBody(cw, ch);
                      },
                    ),
                  ),
                  if (widget.labelPosition == ChordLabelPosition.bottom &&
                      labelWidget != null)
                    labelWidget,
                ],
              ),
            );
          } else {
            return SizedBox(
              width: w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.labelPosition == ChordLabelPosition.top &&
                      labelWidget != null)
                    labelWidget,
                  buildCanvasBody(w, defaultH),
                  if (widget.labelPosition == ChordLabelPosition.bottom &&
                      labelWidget != null)
                    labelWidget,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
