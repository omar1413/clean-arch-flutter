import 'dart:async';

import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/utils/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/block.dart';
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

    if (bloc != null) {
      bloc.close();
    }

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('should initial state to be Empty', () {
    //assert
    expect(bloc.initialState, Empty());
  });

  group('getTriviaForConcreteNumber', () {
    String tNumberStr = '1';
    int tNumber = 1;
    StreamController stateStream;

    setUp(() {
      stateStream = StreamController();
    });
    tearDown(() {
      stateStream.close();
    });

    test('should call inputconvertor to convert a string to a number',
        () async {
      //arrange
      when(mockInputConverter.stringToInt(any)).thenReturn(Right(tNumber));

//      //act
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
  });
}
