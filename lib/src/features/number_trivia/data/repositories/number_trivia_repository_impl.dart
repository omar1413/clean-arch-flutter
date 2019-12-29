import 'package:clean_arch/src/core/error/exeptions.dart';
import 'package:clean_arch/src/core/error/failures.dart';
import 'package:clean_arch/src/core/network/network_info.dart';
import 'package:clean_arch/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_arch/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    print('b');
    return _getTrivia(
        () async => await remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() async => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTriviaModel> fun()) async {
    if (await networkInfo.isConnected) {
      try {
        final numberTriviaModel = await fun();

        localDataSource.cacheNumberTrivia(numberTriviaModel);

        return Right(numberTriviaModel);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
