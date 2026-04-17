import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:summerhack/app/app.dart';
import 'package:summerhack/app/flavor_config.dart';

void main() {
  testWidgets('Summerhack app renders shell scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: SummerhackApp(flavorConfig: FlavorConfig.fromFlavor(AppFlavor.dev)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Welcome to Summerhack'), findsOneWidget);
  });
}
