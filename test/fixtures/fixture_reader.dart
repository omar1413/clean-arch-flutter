import 'dart:io';

String _fixture(String fileName) {
  return File('test/fixtures/$fileName').readAsStringSync();
}

String readTrivial() {
  return _fixture('trivial.json');
}

String readTrivialDouble() {
  return _fixture('trivial-double.json');
}
