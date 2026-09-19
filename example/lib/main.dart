import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';
import 'package:guitar_chord_library/guitar_chord_library.dart';

void main() {
  runApp(const GuitarChordExampleApp());
}

class GuitarChordExampleApp extends StatefulWidget {
  const GuitarChordExampleApp({super.key});

  @override
  State<GuitarChordExampleApp> createState() => _GuitarChordExampleAppState();
}

class _GuitarChordExampleAppState extends State<GuitarChordExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Guitar Chord Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: MainShowcaseScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MainShowcaseScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const MainShowcaseScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<MainShowcaseScreen> createState() => _MainShowcaseScreenState();
}

class _MainShowcaseScreenState extends State<MainShowcaseScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Guitar Chord',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        actions: [
          IconButton(
            tooltip: 'Toggle Theme (${widget.themeMode.name})',
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : widget.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: const [
          PlaygroundTab(),
          ChordExplorerTab(),
          FeatureGalleryTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Playground',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1: INTERACTIVE PLAYGROUND
// ─────────────────────────────────────────────────────────────────────────────

class PlaygroundChordPreset {
  final String name;
  final String frets;
  final String fingers;
  final int baseFret;
  final int totalString;
  final int? rootString;
  final List<String> stringLabels;

  const PlaygroundChordPreset({
    required this.name,
    required this.frets,
    required this.fingers,
    this.baseFret = 1,
    this.totalString = 6,
    this.rootString,
    required this.stringLabels,
  });
}

const List<PlaygroundChordPreset> _guitarPresets = [
  PlaygroundChordPreset(
    name: 'C Major',
    frets: '-1 3 2 0 1 0',
    fingers: '0 3 2 0 1 0',
    rootString: 1,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'G Major',
    frets: '3 2 0 0 0 3',
    fingers: '2 1 0 0 0 3',
    rootString: 0,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'A Minor',
    frets: '-1 0 2 2 1 0',
    fingers: '0 0 2 3 1 0',
    rootString: 1,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'F Major (Barre)',
    frets: '1 3 3 2 1 1',
    fingers: '1 3 4 2 1 1',
    rootString: 0,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'B Minor (Barre)',
    frets: '-1 2 4 4 3 2',
    fingers: '0 1 3 4 2 1',
    baseFret: 2,
    rootString: 1,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'E Major',
    frets: '0 2 2 1 0 0',
    fingers: '0 2 3 1 0 0',
    rootString: 0,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
  PlaygroundChordPreset(
    name: 'D7',
    frets: '-1 -1 0 2 1 2',
    fingers: '0 0 0 2 1 3',
    rootString: 2,
    stringLabels: ['E', 'A', 'D', 'G', 'B', 'e'],
  ),
];

const List<PlaygroundChordPreset> _ukulelePresets = [
  PlaygroundChordPreset(
    name: 'C Major (Uke)',
    frets: '0 0 0 3',
    fingers: '0 0 0 3',
    totalString: 4,
    rootString: 3,
    stringLabels: ['G', 'C', 'E', 'A'],
  ),
  PlaygroundChordPreset(
    name: 'G Major (Uke)',
    frets: '0 2 3 2',
    fingers: '0 1 3 2',
    totalString: 4,
    rootString: 1,
    stringLabels: ['G', 'C', 'E', 'A'],
  ),
  PlaygroundChordPreset(
    name: 'A Minor (Uke)',
    frets: '2 0 0 0',
    fingers: '2 0 0 0',
    totalString: 4,
    rootString: 0,
    stringLabels: ['G', 'C', 'E', 'A'],
  ),
  PlaygroundChordPreset(
    name: 'F Major (Uke)',
    frets: '2 0 1 0',
    fingers: '2 0 1 0',
    totalString: 4,
    rootString: 0,
    stringLabels: ['G', 'C', 'E', 'A'],
  ),
];

class PlaygroundTab extends StatefulWidget {
  const PlaygroundTab({super.key});

  @override
  State<PlaygroundTab> createState() => _PlaygroundTabState();
}

class _PlaygroundTabState extends State<PlaygroundTab> {
  bool _isUkulele = false;
  int _selectedPresetIndex = 0;

  // Customization settings
  bool _leftHanded = false;
  ChordOrientation _orientation = ChordOrientation.vertical;
  ChordLabelPosition _labelPosition = ChordLabelPosition.bottom;
  bool _differentStringStrokes = true;
  bool _showStringLabels = true;
  bool _showFingerNumbers = true;
  bool _labelOpenStrings = true;
  int? _capoFret;
  bool _highlightRoot = true;
  MarkerShape _rootShape = MarkerShape.diamond;

  String _feedbackMessage = 'Tap any note or string on the fretboard!';

  @override
  Widget build(BuildContext context) {
    final presets = _isUkulele ? _ukulelePresets : _guitarPresets;
    final activePreset =
        presets[_selectedPresetIndex.clamp(0, presets.length - 1)];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Instrument toggle
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.music_note),
              label: Text('Guitar (6 Strings)'),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(Icons.audiotrack),
              label: Text('Ukulele (4 Strings)'),
            ),
          ],
          selected: {_isUkulele},
          onSelectionChanged: (set) {
            setState(() {
              _isUkulele = set.first;
              _selectedPresetIndex = 0;
            });
          },
        ),
        const SizedBox(height: 12),

        // Quick Preset Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(presets.length, (index) {
              final p = presets[index];
              final isSelected = index == _selectedPresetIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(p.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPresetIndex = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // HERO CHORD PREVIEW CARD
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: FlutterGuitarChord(
                    chordName: activePreset.name,
                    frets: activePreset.frets,
                    fingers: activePreset.fingers,
                    baseFret: activePreset.baseFret,
                    totalString: activePreset.totalString,
                    width:
                        _orientation == ChordOrientation.vertical ? 195 : 270,
                    height:
                        _orientation == ChordOrientation.vertical ? 255 : 190,
                    leftHanded: _leftHanded,
                    orientation: _orientation,
                    labelPosition: _labelPosition,
                    differentStringStrokes: _differentStringStrokes,
                    stringLabels:
                        _showStringLabels ? activePreset.stringLabels : null,
                    showFingerNumbers: _showFingerNumbers,
                    labelOpenStrings: _labelOpenStrings,
                    capoFret: _capoFret,
                    rootString: _highlightRoot ? activePreset.rootString : null,
                    rootMarkerShape: _rootShape,
                    rootColor: const Color(0xFFFF5252),
                    onNoteTap: (stringIndex, fret) {
                      final label =
                          activePreset.stringLabels.length > stringIndex
                              ? activePreset.stringLabels[stringIndex]
                              : 'S${stringIndex + 1}';
                      setState(() {
                        _feedbackMessage =
                            '🎵 Played Note Tapped: String ${stringIndex + 1} ($label), Fret $fret';
                      });
                    },
                    onStringTap: (stringIndex, fret) {
                      final label =
                          activePreset.stringLabels.length > stringIndex
                              ? activePreset.stringLabels[stringIndex]
                              : 'S${stringIndex + 1}';
                      setState(() {
                        _feedbackMessage =
                            '📍 Fretboard Tapped: String ${stringIndex + 1} ($label), Fret $fret';
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _feedbackMessage,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // FEATURE CONTROLS SECTION
        const Text(
          'Customization & Controls',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // 1. Handedness & Orientation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Orientation & Handedness',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: false,
                            label: Text('Right-Hand'),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text('Left-Hand'),
                          ),
                        ],
                        selected: {_leftHanded},
                        onSelectionChanged: (set) =>
                            setState(() => _leftHanded = set.first),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<ChordOrientation>(
                        segments: const [
                          ButtonSegment(
                            value: ChordOrientation.vertical,
                            label: Text('Vertical'),
                          ),
                          ButtonSegment(
                            value: ChordOrientation.horizontal,
                            label: Text('Horizontal'),
                          ),
                        ],
                        selected: {_orientation},
                        onSelectionChanged: (set) =>
                            setState(() => _orientation = set.first),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<ChordLabelPosition>(
                        segments: const [
                          ButtonSegment(
                            value: ChordLabelPosition.bottom,
                            label: Text('Label Bottom'),
                          ),
                          ButtonSegment(
                            value: ChordLabelPosition.top,
                            label: Text('Label Top'),
                          ),
                        ],
                        selected: {_labelPosition},
                        onSelectionChanged: (set) =>
                            setState(() => _labelPosition = set.first),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 2. Fretboard Visual Options
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('String Thickness Gradient'),
                subtitle: const Text('Natural wound-string gauge variation'),
                value: _differentStringStrokes,
                onChanged: (v) => setState(() => _differentStringStrokes = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Tuning String Labels'),
                subtitle: const Text(
                    'Displays note names (E A D G B e) below strings'),
                value: _showStringLabels,
                onChanged: (v) => setState(() => _showStringLabels = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Finger Numbers'),
                subtitle:
                    const Text('Show finger index or clean solid markers'),
                value: _showFingerNumbers,
                onChanged: (v) => setState(() => _showFingerNumbers = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Open & Muted Indicators'),
                subtitle: const Text('Display O and X above strings'),
                value: _labelOpenStrings,
                onChanged: (v) => setState(() => _labelOpenStrings = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 3. Capo & Root Note
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Capo Bar Indicator',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    DropdownButton<int?>(
                      value: _capoFret,
                      hint: const Text('None'),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('No Capo')),
                        ...List.generate(5, (i) => i + 1).map(
                          (fret) => DropdownMenuItem(
                            value: fret,
                            child: Text('Capo Fret $fret'),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _capoFret = v),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Root Note (Tonic) Highlight',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value: _highlightRoot,
                      onChanged: (v) => setState(() => _highlightRoot = v),
                    ),
                  ],
                ),
                if (_highlightRoot) ...[
                  const SizedBox(height: 8),
                  const Text('Marker Shape:',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<MarkerShape>(
                          segments: const [
                            ButtonSegment(
                              value: MarkerShape.circle,
                              label: Text('Circle'),
                              icon: Icon(Icons.circle, size: 14),
                            ),
                            ButtonSegment(
                              value: MarkerShape.square,
                              label: Text('Square'),
                              icon: Icon(Icons.square, size: 14),
                            ),
                            ButtonSegment(
                              value: MarkerShape.diamond,
                              label: Text('Diamond'),
                              icon: Icon(Icons.change_history, size: 14),
                            ),
                          ],
                          selected: {_rootShape},
                          onSelectionChanged: (set) =>
                              setState(() => _rootShape = set.first),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2: FULL CHORD EXPLORER (Powered by guitar_chord_library)
// ─────────────────────────────────────────────────────────────────────────────

class ChordExplorerTab extends StatefulWidget {
  const ChordExplorerTab({super.key});

  @override
  State<ChordExplorerTab> createState() => _ChordExplorerTabState();
}

class _ChordExplorerTabState extends State<ChordExplorerTab> {
  bool _isUkulele = false;
  bool _useFlat = true;
  bool _leftHanded = false;
  bool _useThickness = true;

  @override
  Widget build(BuildContext context) {
    final instrument = _isUkulele
        ? GuitarChordLibrary.instrument(InstrumentType.ukulele)
        : GuitarChordLibrary.instrument();

    final keys = instrument.getKeys(_useFlat);

    return DefaultTabController(
      length: keys.length,
      child: Column(
        children: [
          // Filter Toolbar
          Material(
            elevation: 1,
            color: Theme.of(context).colorScheme.surface,
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                children: [
                  DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: DropdownButton<bool>(
                        value: _isUkulele,
                        isDense: true,
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Guitar')),
                          DropdownMenuItem(value: true, child: Text('Ukulele')),
                        ],
                        onChanged: (v) =>
                            setState(() => _isUkulele = v ?? false),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(_useFlat ? '♭ Flat' : '♯ Sharp'),
                    selected: _useFlat,
                    onSelected: (v) => setState(() => _useFlat = v),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Left-Hand'),
                    selected: _leftHanded,
                    onSelected: (v) => setState(() => _leftHanded = v),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Gauge'),
                    selected: _useThickness,
                    onSelected: (v) => setState(() => _useThickness = v),
                  ),
                ],
              ),
            ),
          ),

          // Key Tabs
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: keys.map((k) => Tab(text: k)).toList(),
          ),

          // Chord Grid Views
          Expanded(
            child: TabBarView(
              children: keys.map((key) {
                final chords = instrument.getChordsByKey(key, _useFlat) ?? [];

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth <= 0) {
                      return const SizedBox.shrink();
                    }
                    final crossAxisCount =
                        (constraints.maxWidth / 170).floor().clamp(2, 6);

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: chords.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisExtent: 255,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final chord = chords[index];
                        final position = chord.chordPositions.first;

                        return Card(
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            child: FlutterGuitarChord(
                              chordName: chord.name,
                              baseFret: position.baseFret,
                              fingers: position.fingers,
                              frets: position.frets,
                              totalString: instrument.stringCount,
                              leftHanded: _leftHanded,
                              differentStringStrokes: _useThickness,
                              labelOpenStrings: true,
                              stringLabels: instrument.stringCount == 4
                                  ? const ['G', 'C', 'E', 'A']
                                  : const ['E', 'A', 'D', 'G', 'B', 'e'],
                              onNoteTap: (stringIndex, fret) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${chord.name}: String ${stringIndex + 1}, Fret $fret',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3: FEATURE GALLERY (Showcasing all features side-by-side)
// ─────────────────────────────────────────────────────────────────────────────

class FeatureGalleryTab extends StatelessWidget {
  const FeatureGalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Right-Hand vs Left-Hand Comparison
        _buildSectionHeader('1. Right-Handed vs Left-Handed (Issue #5)'),
        const Text(
          'Left-handed players can view perfectly mirrored fretboards while labels and numbers remain upright.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Right-Handed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      FlutterGuitarChord(
                        chordName: 'C Major',
                        frets: '-1 3 2 0 1 0',
                        fingers: '0 3 2 0 1 0',
                        baseFret: 1,
                        height: 220,
                        stringLabels: const ['E', 'A', 'D', 'G', 'B', 'e'],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Left-Handed (Mirrored)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      FlutterGuitarChord(
                        chordName: 'C Major',
                        frets: '-1 3 2 0 1 0',
                        fingers: '0 3 2 0 1 0',
                        baseFret: 1,
                        leftHanded: true,
                        height: 220,
                        stringLabels: const ['E', 'A', 'D', 'G', 'B', 'e'],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Vertical vs Horizontal Orientation
        _buildSectionHeader('2. Vertical vs Horizontal Orientation'),
        const Text(
          'Supports horizontal orientation ideal for landscape mode, tablet displays, and tabs view.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  'Horizontal Fretboard (Nut on Left, Frets to Right)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Center(
                  child: FlutterGuitarChord(
                    chordName: 'F Major (Barre)',
                    frets: '1 3 3 2 1 1',
                    fingers: '1 3 4 2 1 1',
                    baseFret: 1,
                    orientation: ChordOrientation.horizontal,
                    height: 180,
                    width: 280,
                    labelOpenStrings: true,
                    stringLabels: const ['E', 'A', 'D', 'G', 'B', 'e'],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Capo & Root Note Highlights
        _buildSectionHeader('3. Capo Clamp & Root Note Shapes'),
        const Text(
          'Capo clamp bar across any fret, and distinct root/bass note shapes (Diamond, Square, Circle).',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Capo @ Fret 2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      FlutterGuitarChord(
                        chordName: 'G Major (Capo 2)',
                        frets: '3 2 0 0 0 3',
                        fingers: '2 1 0 0 0 3',
                        baseFret: 1,
                        capoFret: 2,
                        height: 220,
                        stringLabels: const ['E', 'A', 'D', 'G', 'B', 'e'],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Diamond Root',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      FlutterGuitarChord(
                        chordName: 'C Major',
                        frets: '-1 3 2 0 1 0',
                        fingers: '0 3 2 0 1 0',
                        baseFret: 1,
                        rootString: 1,
                        rootMarkerShape: MarkerShape.diamond,
                        rootColor: Colors.redAccent,
                        height: 220,
                        stringLabels: const ['E', 'A', 'D', 'G', 'B', 'e'],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 4. Ukulele 4-String Instruments
        _buildSectionHeader('4. Multi-Instrument Support (Ukulele 4-String)'),
        const Text(
          'Fully configurable totalString count adapts smoothly to 4-string ukulele or bass.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: FlutterGuitarChord(
                    chordName: 'C Major',
                    frets: '0 0 0 3',
                    fingers: '0 0 0 3',
                    baseFret: 1,
                    totalString: 4,
                    height: 200,
                    labelOpenStrings: true,
                    stringLabels: const ['G', 'C', 'E', 'A'],
                  ),
                ),
                Expanded(
                  child: FlutterGuitarChord(
                    chordName: 'G Major',
                    frets: '0 2 3 2',
                    fingers: '0 1 3 2',
                    baseFret: 1,
                    totalString: 4,
                    height: 200,
                    labelOpenStrings: true,
                    stringLabels: const ['G', 'C', 'E', 'A'],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
