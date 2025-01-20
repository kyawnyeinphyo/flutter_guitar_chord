import 'package:flutter/material.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';
import 'package:guitar_chord_library/guitar_chord_library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _instrumentList = ['Guitar', 'Ukulele'];
  String? _selection;
  bool _useFlat = true;

  @override
  Widget build(BuildContext context) {
    var instrument = (_selection == null || _selection == 'Guitar')
        ? GuitarChordLibrary.instrument()
        : GuitarChordLibrary.instrument(InstrumentType.ukulele);

    var keys = instrument.getKeys(_useFlat);

    return DefaultTabController(
      length: keys.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: DropdownButton<String>(
            value: _selection ?? _instrumentList[0],
            onChanged: (value) => setState(() {
              _selection = value;
            }),
            items: _instrumentList
                .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                .toList(),
          ),
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Flat Note ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: _useFlat,
                      onChanged: (v) {
                        setState(() {
                          _useFlat = v;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 24),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.orange,
            indicatorColor: Colors.orange,
            tabs: keys.map((e) {
              return Tab(text: e);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: keys.map(
            (e) {
              var chords = instrument.getChordsByKey(e, _useFlat);

              return GridView.builder(
                itemCount: chords!.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  var chord = chords[index];
                  var position = chord
                      .chordPositions[0]; //I will use the first one for example
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FlutterGuitarChord(
                          baseFret: position.baseFret,
                          chordName: chord.name,
                          fingers: position.fingers,
                          frets: position.frets,
                          totalString: instrument.stringCount,
                          // labelColor: Colors.teal,
                          // tabForegroundColor: Colors.white,
                          // tabBackgroundColor: Colors.deepOrange,
                          // barColor: Colors.black,
                          // stringColor: Colors.red,
                          // labelOpenStrings: true,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
