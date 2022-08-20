import 'package:flutter_test/flutter_test.dart';
import 'package:readable_cryption/providers/serverProvider.dart';

Future<void> main() async {
  final server = ServerProvider();
  const testUsername = "test_hesabi";
  const testPassword = "test_hesabi";
  var tokenTime;

  test('Login testi', () async {
    await server.login(username: testUsername, password: testPassword);
    expect(server.token, isNot(equals(null)));
    tokenTime = DateTime.now();
  });

  test('Check Token', () async {
    var timeDiff = DateTime.now().difference(tokenTime);
    bool expired = timeDiff.inMinutes > 30;

    expect(await server.checkToken(), isNot(equals(expired)));
  });
}
