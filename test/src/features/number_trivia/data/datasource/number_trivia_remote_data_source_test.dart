import 'dart:convert';

import 'package:clean_arch/src/core/base/api.dart';
import 'package:clean_arch/src/core/error/exeptions.dart';
import 'package:clean_arch/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:matcher/matcher.dart' as Match;
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockApi extends Mock implements Api {}

void main() {
  MockApi mockApi;
  NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockApi = MockApi();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(mockApi);
  });

  void setupMockApiSuccess200() {
    when(mockApi.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(readTrivia(), 200));
  }

  void setupMockApiFailure404() {
    when(mockApi.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(readTrivia(), 404));
  }

  group('getConcreteNumberTrivia', () {
    void verifyMockApiGetCalledOnNumberEndPoint(int number) {
      verify(mockApi.get(
        '${Api.BASE_URL}${EndPoints.number}$number',
        headers: {'Content-Type': 'application/json'},
      ));
    }

    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(readTrivia()));
    test(
        'should Get request with number endpoint with content type apllication/json',
        () async {
      setupMockApiSuccess200();

      remoteDataSource.getConcreteNumberTrivia(tNumber);

      verifyMockApiGetCalledOnNumberEndPoint(tNumber);
    });

    test('should throw SereverException when responcse code in not 200',
        () async {
      setupMockApiFailure404();

      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(Match.TypeMatcher<ServerException>()));
      verifyMockApiGetCalledOnNumberEndPoint(tNumber);
    });

    test('should return NumberTrivia when response code is 200', () async {
      setupMockApiSuccess200();

      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      expect(result, tNumberTriviaModel);
      verifyMockApiGetCalledOnNumberEndPoint(tNumber);
    });
  });

  group('getRandomNumberTrivia', () {
    void verifyMockApiGetCalledOnRandomEndPoint() {
      verify(mockApi.get(
        Api.BASE_URL + EndPoints.random,
        headers: {'Content-Type': 'application/json'},
      ));
    }

    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(readTrivia()));
    test(
        'should Get request with number endpoint with content type apllication/json',
        () async {
      setupMockApiSuccess200();

      remoteDataSource.getRandomNumberTrivia();

      verifyMockApiGetCalledOnRandomEndPoint();
    });

    test('should throw SereverException when responcse code in not 200',
        () async {
      setupMockApiFailure404();

      final call = remoteDataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(Match.TypeMatcher<ServerException>()));
      verifyMockApiGetCalledOnRandomEndPoint();
    });

    test('should return NumberTrivia when response code is 200', () async {
      setupMockApiSuccess200();

      final result = await remoteDataSource.getRandomNumberTrivia();

      expect(result, tNumberTriviaModel);
      verifyMockApiGetCalledOnRandomEndPoint();
    });
  });
}
