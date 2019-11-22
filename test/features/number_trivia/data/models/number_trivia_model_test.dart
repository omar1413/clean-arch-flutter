import 'dart:convert';

import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final numberTriviaModel = NumberTriviaModel(text: 'test text', number: 1);

  test('should be a subclass of NumberTrivia entity', () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the json number is integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(readTrivial());

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(numberTriviaModel));
    });

    test('should return a valid model when the json number is integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(readTrivialDouble());

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(numberTriviaModel));
    });
  });

  group('toJson', () {
    test('should return a json map containing the proper data', () async {
      final Map<String, dynamic> expectedJson = {
        "text": "test text",
        "number": 1,
      };

      final result = numberTriviaModel.toJson();

      expect(result, expectedJson);
    });
  });
}
