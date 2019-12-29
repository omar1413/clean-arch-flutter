import 'dart:convert';

import 'package:clean_arch/src/core/error/exeptions.dart';
import 'package:clean_arch/src/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}

const String CACHED_NUMBER_TRIVIA = 'LAST_NUMBER';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache) async {
    final jsonStr = json.encode(triviaCache.toJson());
    final success =
        await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonStr);
    if (!success) {
      throw CacheException();
    }
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    String jsonStr = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonStr == null) {
      return throw CacheException();
    }
    final numberTrivia =
        Future.value(NumberTriviaModel.fromJson(json.decode(jsonStr)));
    return numberTrivia;
  }
}
