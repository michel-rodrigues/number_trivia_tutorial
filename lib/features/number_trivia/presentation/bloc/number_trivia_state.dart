import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';


@imutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}


class Empty extends NumberTriviaState {}


class Loading extends NumberTriviaState {}


class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded({@required this.trivia}) : super([trivia]);
}


class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message}) : super([message]);
}