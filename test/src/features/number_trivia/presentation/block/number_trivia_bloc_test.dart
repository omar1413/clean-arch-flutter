import 'dart:async';

import 'package:clean_arch/src/core/error/failures.dart';
import 'package:clean_arch/src/core/usecases/usecase.dart';
import 'package:clean_arch/src/core/utils/input_converter.dart';
import 'package:clean_arch/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/bloc/block.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('should initial state to be Empty', () {
    //assert
    expect(bloc.initialState, Empty());
  });

  group('getTriviaForConcreteNumber', () {
    String tNumberStr = '1';
    int tNumber = 1;
    NumberTrivia tNumberTrivia =
        NumberTrivia(text: 'test text', number: tNumber);
    StreamController stateStream;

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToInt(any)).thenReturn(Right(tNumber));
    }

    void setUpMockGetConcreteNumberTriviaSuccess() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    setUp(() {
      stateStream = StreamController();
    });
    tearDown(() {
      stateStream.close();
    });

    test('should call inputconvertor to convert a string to a number',
        () async {
      //arrange
      setUpMockInputConverterSuccess();

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));

      await untilCalled(mockInputConverter.stringToInt(any));
      verify(mockInputConverter.stringToInt(tNumberStr));
    });

    test('should return Error state when inputConvertor return a Failure',
        () async {
      //arrange
      when(mockInputConverter.stringToInt(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = emitsInOrder([
        Empty(),
        Error(INVALID_INPUT_ERROR_MESSAGE),
      ]);

      //assert later
      expectLater(stateStream.stream, expected);

      //act
      bloc.listen((e) {
        stateStream.sink.add(e);
      });

      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
    });

    test('should verify getconcrete use case is called', () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumber)));
    });

    test('should emit [loading ,loaded] when get data is successful', () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(tNumberTrivia),
      ];
      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((value) => stateStream.sink.add(value));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
    });

    test(
        'should emit Loading state before getconcrete numberTrivia called when data get it successful',
        () async {
      //arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 2));
        return Right(tNumberTrivia);
      });
      bool loadingStateCalled = true;
      //act
      bloc.listen((value) {
        if (value is Loading) {
          expect(loadingStateCalled, true);
        }
      });

      bloc.add(GetTriviaForConcreteNumber(tNumberStr));

      //assert
      await Future.delayed(Duration(seconds: 1));
      loadingStateCalled = false;
      await untilCalled(mockGetConcreteNumberTrivia(any));
      await Future.delayed(Duration(seconds: 2));
    });

    test(
        'should emit [loading , Error] when gotten data failed and therer is ServerFailure',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(SERVER_ERROR_MESSAGE),
      ];

      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((val) => stateStream.sink.add(val));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
    });

    test(
        'should emit [loading , Error] when gotten data failed and therer is CacheFailure',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(CACHE_ERROR_MESSAGE),
      ];

      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((val) => stateStream.sink.add(val));
      bloc.add(GetTriviaForConcreteNumber(tNumberStr));
    });
  });

  group('getTriviaForRandomNumber', () {
    NumberTrivia tNumberTrivia = NumberTrivia(text: 'test text', number: 1);
    StreamController stateStream;

    void setUpMockGetRandomNumberTriviaSuccess() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    setUp(() {
      stateStream = StreamController();
    });
    tearDown(() {
      stateStream.close();
    });

    test('should verify getRandom use case is called', () async {
      //arrange
      setUpMockGetRandomNumberTriviaSuccess();

      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [loading ,loaded] when get data is successful', () async {
      //arrange

      setUpMockGetRandomNumberTriviaSuccess();
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(tNumberTrivia),
      ];
      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((value) => stateStream.sink.add(value));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit Loading state before getRandom numberTrivia called when data get it successful',
        () async {
      //arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 2));
        return Right(tNumberTrivia);
      });
      bool loadingStateCalled = true;
      //act
      bloc.listen((value) {
        if (value is Loading) {
          expect(loadingStateCalled, true);
        }
      });

      bloc.add(GetTriviaForRandomNumber());

      //assert
      await Future.delayed(Duration(seconds: 1));
      loadingStateCalled = false;
      await untilCalled(mockGetRandomNumberTrivia(any));
      await Future.delayed(Duration(seconds: 2));
    });

    test(
        'should emit [loading , Error] when gotten data failed and therer is ServerFailure',
        () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(SERVER_ERROR_MESSAGE),
      ];

      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((val) => stateStream.sink.add(val));
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [loading , Error] when gotten data failed and therer is CacheFailure',
        () async {
      //arrange

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(CACHE_ERROR_MESSAGE),
      ];

      expectLater(stateStream.stream, emitsInOrder(expected));

      //act
      bloc.listen((val) => stateStream.sink.add(val));
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
