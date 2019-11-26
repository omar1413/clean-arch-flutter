import 'dart:convert';

import 'package:clean_arch/core/base/api.dart';
import 'package:clean_arch/core/error/exeptions.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';

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
    final res = await api.get(
      Api.BASE_URL + endpoint,
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode != 200) {
      throw ServerException();
    }
    return NumberTriviaModel.fromJson(json.decode(res.body));
  }
}
