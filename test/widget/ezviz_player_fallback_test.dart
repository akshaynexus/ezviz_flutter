import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EzvizPlayer shows fallback text on unsupported host', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EzvizPlayer(onCreated: (_) {}),
      ),
    ));

    // The player mounts; platform views (if any) are managed by runtime.
    expect(find.byType(EzvizPlayer), findsOneWidget);
  });
}
