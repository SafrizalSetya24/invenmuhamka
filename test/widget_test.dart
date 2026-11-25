import 'package:flutter_test/flutter_test.dart';

import 'package:invenmuhamka/main.dart';

void main() {
  testWidgets('Login screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const InvenMuhamkaApp());
    expect(find.text('Selamat Datang'), findsOneWidget);
  });
}
