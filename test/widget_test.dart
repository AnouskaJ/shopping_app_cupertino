import 'package:shopping_app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App start test', (tester) async {
    await tester.pumpWidget(const CupertinoStoreApp());
    expect(find.text('Shopping Store'), findsOneWidget);
  });
}
