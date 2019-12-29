import 'package:bloc/bloc.dart';
import 'package:clean_arch/src/core/error/failures.dart';
import 'package:clean_arch/src/core/usecases/usecase.dart';
import 'package:clean_arch/src/core/utils/input_converter.dart';
import 'package:clean_arch/src/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/src/features/number_trivia/presentation/bloc/block.dart';
import 'package:dartz/dartz.dart';

const String SERVER_ERROR_MESSAGE = 'Server Error';
const String CACHE_ERROR_MESSAGE = 'Cache Error';
const String INVALID_INPUT_ERROR_MESSAGE =
    'invalid input , input should be a postive number';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    GetConcreteNumberTrivia concrete,
    GetRandomNumberTrivia random,
    this.inputConverter,
  })  : assert(concrete != null && random != null && inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      print(event);
      final eitherInput = inputConverter.stringToInt(event.number);

      yield* eitherInput.fold(
        (_) async* {
          print('1');
          yield Error(INVALID_INPUT_ERROR_MESSAGE);
        },
        (number) async* {
          print('2');
          yield Loading();
          final eitherTriviaOrFailure =
              await getConcreteNumberTrivia(Params(number: number));
          print('2');
          yield* _triviaOrFailure(eitherTriviaOrFailure);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();

      final eitherTriviaOrFailure = await getRandomNumberTrivia(NoParams());

      yield* _triviaOrFailure(eitherTriviaOrFailure);
    }
  }

  Stream<NumberTriviaState> _triviaOrFailure(
      Either<Failure, NumberTrivia> eitherTriviaOrFailure) async* {
    yield eitherTriviaOrFailure.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (numberTrivia) => Loaded(numberTrivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_ERROR_MESSAGE;
      case CacheFailure:
        return CACHE_ERROR_MESSAGE;
      default:
        return 'Unexpected Failure';
    }
  }
}
