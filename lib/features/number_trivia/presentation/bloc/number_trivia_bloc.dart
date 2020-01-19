import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:number_trivia_tutorial/core/utils/input_converter.dart';
import './bloc.dart';


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  NumberTriviaState get initialState => InitialNumberTriviaState();

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {

  }
}
