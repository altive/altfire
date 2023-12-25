import 'package:flutter_test/flutter_test.dart';

void main() {
  // This is a temporary solution for the issue where tests fail if there
  // are no test files present. It is circumvented by adding a simple test
  // that always succeeds.
  test('Dummy Test', () {
    expect(true, true);
  });
}
