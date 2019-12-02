import 'package:bloc/bloc.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/block.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}
