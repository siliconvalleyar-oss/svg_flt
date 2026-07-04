import 'package:flutter_test/flutter_test.dart';

import 'package:animated_app/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AnimatedApp());
    expect(find.text('Bienvenido'), findsOneWidget);
  });
}
