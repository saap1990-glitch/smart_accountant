import 'package:flutter_test/flutter_test.dart';
import 'package:smart_accountant/app/app.dart';

void main() {
  testWidgets('Smart Accountant app loads', (tester) async {
    await tester.pumpWidget(const SmartAccountantApp());

    expect(find.text('دفتر المحاسب الذكي'), findsOneWidget);
  });
}
