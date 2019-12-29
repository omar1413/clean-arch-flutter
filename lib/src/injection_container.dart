import 'package:clean_arch/src/core/base/api.dart';
import 'package:clean_arch/src/core/network/network_info.dart';
import 'package:clean_arch/src/core/utils/input_converter.dart';
import 'package:clean_arch/src/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_arch/src/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/src/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/bloc/block.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart' as DI;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

final di = DI.GetIt.instance;

init() async {
  //features
  di.registerFactory(
    () => NumberTriviaBloc(
      concrete: di(),
      random: di(),
      inputConverter: di(),
    ),
  );

  di.registerLazySingleton(
    () => GetConcreteNumberTrivia(di()),
  );
  di.registerLazySingleton(
    () => GetRandomNumberTrivia(di()),
  );

  di.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: di(),
      localDataSource: di(),
      networkInfo: di(),
    ),
  );

  di.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(di()),
  );

  //core
  di.registerLazySingleton(
    () => InputConverter(),
  );
  di.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(di()),
  );

  di.registerLazySingleton<Api>(
    () => ApiImpl(di()),
  );

  //library
  final sharedPref = await SharedPreferences.getInstance();
  di.registerLazySingleton<SharedPreferences>(
    () => sharedPref,
  );

  di.registerLazySingleton(
    () => DataConnectionChecker(),
  );

  di.registerLazySingleton(
    () => http.Client(),
  );
}
