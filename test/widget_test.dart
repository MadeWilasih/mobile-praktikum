import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_fundamentals/widgets/role_guard.dart';

void main() {
  testWidgets('RoleGuard menampilkan child untuk role yang diizinkan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoleGuard(
            role: 'owner',
            allowed: const ['owner', 'admin'],
            child: const Text('Tambah Kos'),
          ),
        ),
      ),
    );

    expect(find.text('Tambah Kos'), findsOneWidget);
  });

  testWidgets(
    'RoleGuard menyembunyikan child untuk role yang tidak diizinkan',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RoleGuard(
              role: 'seeker',
              allowed: const ['owner', 'admin'],
              child: const Text('Tambah Kos'),
            ),
          ),
        ),
      );

      expect(find.text('Tambah Kos'), findsNothing);
    },
  );
}
