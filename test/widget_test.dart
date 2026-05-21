import 'package:flutter_test/flutter_test.dart';

import 'package:safmeh/main.dart';

void main() {
  testWidgets('SafMeh app renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SafMehApp());
    await tester.pump();

    // App renders without crashing — login screen is the home
    expect(find.byType(SafMehApp), findsOneWidget);
  });
}
