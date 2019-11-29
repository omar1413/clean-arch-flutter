import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded(this.trivia);

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String msg;

  Error(this.msg);

  @override
  List<Object> get props => [msg];
}
