import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;

  GetTriviaForConcreteNumber(this.number);

  @override
  List<Object> get props => [number];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
