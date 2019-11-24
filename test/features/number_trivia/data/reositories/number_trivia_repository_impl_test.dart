import 'package:clean_arch/core/error/exeptions.dart';
import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/platform/network_info.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test text');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    act() {
      return repository.getConcreteNumberTrivia(tNumber);
    }

    test('should check if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await act();

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      tearDown(() {
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });

      validArrange() {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
      }

      exceptionArrange() {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
      }

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        validArrange();

        final result = await act();

        expect(result, Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        validArrange();

        await act();

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        exceptionArrange();

        final result = await act();

        expect(result, Left(ServerFailure()));

        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('device is offline', () {
      tearDown(() {
        verify(mockLocalDataSource.getLastNumberTrivia());
      });
      validArrange() {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      }

      exceptionArrange() {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
      }

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'should return last locally cached data when the cache data is present',
          () async {
        validArrange();

        final result = await act();

        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, Right(tNumberTrivia));
      });

      test('should return cache failure when the cache data is not present',
          () async {
        exceptionArrange();

        final result = await act();

        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    act() {
      return repository.getRandomNumberTrivia();
    }

    test('should check if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await act();

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      tearDown(() {
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });
      validArrange() {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      }

      exceptionArrange() {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
      }

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        validArrange();

        final result = await act();

        expect(result, Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        validArrange();

        await act();

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        exceptionArrange();

        final result = await act();

        expect(result, Left(ServerFailure()));

        verifyZeroInteractions(mockLocalDataSource);
      });
    });

    group('device is offline', () {
      validArrange() {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      }

      exceptionArrange() {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
      }

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      tearDown(() {
        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
      });
      test(
          'should return last locally cached data when the cache data is present',
          () async {
        validArrange();

        final result = await act();

        expect(result, Right(tNumberTrivia));
      });

      test('should return cache failure when the cache data is not present',
          () async {
        exceptionArrange();

        final result = await act();

        expect(result, Left(CacheFailure()));
      });
    });
  });
}
