import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:flutter_guitar_chord/flutter_guitar_chord.dart';

void main() {
  testWidgets('Example app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GuitarChordExampleApp());
    await tester.pumpAndSettle();

    expect(find.byType(FlutterGuitarChord), findsWidgets);
    expect(find.text('Guitar (6 Strings)'), findsOneWidget);
  });
}
