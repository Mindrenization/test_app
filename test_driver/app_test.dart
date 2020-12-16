import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Главная страница', () {
    final addBranchButtonFinder = find.byValueKey('addBranchButton');
    final branchTextFieldFinder = find.byValueKey('branchTextField');
    final confirmCreateBranchFinder = find.byValueKey('confirmCreateBranch');
    final branchTileFinder = find.byValueKey('branchTile');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Создание ветки', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(addBranchButtonFinder);
        await driver.tap(branchTextFieldFinder);
        await driver.enterText('Title');
        await driver.tap(confirmCreateBranchFinder);
        await driver.waitFor(branchTileFinder);
      });
    });
  });
}
