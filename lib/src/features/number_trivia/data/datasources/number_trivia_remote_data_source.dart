import 'dart:convert';

import 'package:clean_arch/src/core/base/api.dart';
import 'package:clean_arch/src/core/error/exeptions.dart';
import 'package:clean_arch/src/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Api api;

  NumberTriviaRemoteDataSourceImpl(this.api);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      getNumberOrRandom('${EndPoints.number}$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      getNumberOrRandom(EndPoints.random);

  Future<NumberTriviaModel> getNumberOrRandom(String endpoint) async {
    final x = api.get(
      Api.BASE_URL + endpoint,
      headers: {'Content-Type': 'application/json'},
    );

    final res = await x;
    if (res.statusCode != 200) {
      throw ServerException();
    }

    return NumberTriviaModel.fromJson(json.decode(res.body));
  }
}
