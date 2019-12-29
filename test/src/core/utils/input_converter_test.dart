import 'package:clean_arch/src/core/error/failures.dart';
import 'package:clean_arch/src/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToInt', () {
    test('should return valid integer for the valid string in the parameter',
        () async {
      //arrange
      List<String> strs = ['123', '528', '453'];
      //act
      final result0 = inputConverter.stringToInt(strs[0]);
      final result1 = inputConverter.stringToInt(strs[1]);
      final result2 = inputConverter.stringToInt(strs[2]);
      //assert
      expect(result0, Right(int.parse(strs[0])));
      expect(result1, Right(int.parse(strs[1])));
      expect(result2, Right(int.parse(strs[2])));
    });

    test('should return Failure when the string is not an integer', () {
      //arrange
      String str = '12r';
      //act
      final result = inputConverter.stringToInt(str);
      //expect
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return Failure when the string is negative', () {
      //arrange
      String str = '-12';
      //act
      final result = inputConverter.stringToInt(str);
      //expect
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return Failure when string is empty', () {
      //arrange
      String str = '';
      //act
      final result = inputConverter.stringToInt(str);
      //expect
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return Failure when string is null', () {
      //arrange
      String str;
      //act
      final result = inputConverter.stringToInt(str);
      //expect
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
