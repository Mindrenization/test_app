import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/data/models/branch.dart';
import 'package:test_app/presentation/widgets/branch_tile.dart';

void main() {
  group('BranchTile', () {
    testWidgets('Отображается название ветки', (WidgetTester tester) async {
      final branch = Branch('1', 'Branch1');
      branch.tasks = [];
      await tester.pumpWidget(
        MaterialApp(
          home: BranchTile(
            branch,
          ),
        ),
      );
      expect(find.text(branch.title), findsOneWidget);
    });
  });
}
