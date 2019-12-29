import 'package:clean_arch/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String str) {
    if (str == null) return Left(InvalidInputFailure());

    try {
      final num = int.parse(str);
      if (num < 0) throw FormatException();

      return Right(num);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
