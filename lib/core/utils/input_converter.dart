import 'package:clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String str) {
    try {
      final num = int.parse(str);
      if (num < 0) throw FormatException();
      return Right(num);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
