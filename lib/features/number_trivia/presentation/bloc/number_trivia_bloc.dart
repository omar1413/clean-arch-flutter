import 'package:bloc/bloc.dart';
import 'package:clean_arch/core/utils/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/block.dart';

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
      final eitherInput = inputConverter.stringToInt(event.number);
      yield* eitherInput.fold(
        (_) async* {
          yield Error(INVALID_INPUT_ERROR_MESSAGE);
        },
        (_) {
          throw UnimplementedError();
        },
      );
    }
  }
}
