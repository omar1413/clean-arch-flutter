import 'dart:convert';

import 'package:clean_arch/core/error/exeptions.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as Match;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl localDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  group('getLatsNumberTrivia', () {
    final tNumberTrivia = NumberTriviaModel(number: 1, text: 'test text');
    test('should return a NumberTrivia when there is one in sharedPreference',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(readTriviaCached());

      final result = await localDataSource.getLastNumberTrivia();

      expect(result, tNumberTrivia);
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
    });
    test('should throw cahce expception when shared preferences is empty',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = localDataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(Match.TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    test('should call the sharedPreferences to cache the data', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      localDataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonStr = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonStr));
    });

    test(
        'should throw cache exception when sharedpreferences return false on cache data',
        () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => false);

      final call = localDataSource.cacheNumberTrivia;

      expect(() => call(tNumberTriviaModel),
          throwsA(Match.TypeMatcher<CacheException>()));
    });
  });
}
