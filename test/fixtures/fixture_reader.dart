import 'dart:io';

String _fixture(String fileName) {
  return File('test/fixtures/$fileName').readAsStringSync();
}

String readTrivia() {
  return _fixture('trivia.json');
}

String readTriviaDouble() {
  return _fixture('trivia-double.json');
}

String readTriviaCached() {
  return _fixture('trivia_cached.json');
}
