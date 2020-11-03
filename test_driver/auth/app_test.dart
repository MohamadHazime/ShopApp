import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Flutter Auth App Test:\n", () {
    final email = find.byValueKey('email');
    final password = find.byValueKey('password');
    final btn = find.byValueKey('btn');
    final prods = find.byType('ProductsOverviewScreen');
    final dialog = find.byType('AlertDialog');
    final text1 = find.text('Could not found a user with that email.');
    final text2 = find.text('Invalid password.');
    final drawer = find.byTooltip('Open navigation menu');
    final logout = find.byValueKey('logout');
    final okay = find.text('Okay');
    final onlyFav = find.byValueKey('onlyFav');
    final menu = find.byValueKey('Menu');

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('1- Test success login.\n', () async {
      await driver.tap(email);
      await driver.enterText("test@test.com");
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(password);
      await driver.enterText("test1234");
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(btn);
      await driver.waitFor(prods);
      assert(prods != null);
      await driver.waitUntilNoTransientCallbacks();
    }, timeout: Timeout.none);

    test('2- Test failed login with incorrect email or password.\n', () async {
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(menu);
      assert(menu != null);
      await driver.tap(menu);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(onlyFav);
      assert(onlyFav != null);
      await driver.tap(onlyFav);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(drawer);
      assert(drawer != null);
      await driver.tap(drawer);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(logout);
      assert(dialog != null);
      await driver.tap(logout);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(email);
      assert(dialog != null);
      await driver.tap(email);
      await driver.enterText("test5@test.com");
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(password);
      await driver.enterText("test1234");
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(btn);
      await driver.waitFor(dialog);
      assert(dialog != null);
      await driver.waitFor(text1);
      assert(text1 != null);
      await driver.waitFor(okay);
      assert(okay != null);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(okay);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(email);
      await driver.enterText('test@test.com');
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(password);
      await driver.enterText("testjkjk");
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.tap(btn);
      await Future.delayed(Duration(seconds: 5), () {});
      await driver.waitFor(dialog);
      assert(dialog != null);
      await driver.waitFor(text2);
      assert(text2 != null);
      await driver.waitFor(okay);
      assert(okay != null);
      await driver.tap(okay);
      await driver.waitUntilNoTransientCallbacks();
    }, timeout: Timeout.none);
  });
}
