import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_tutorial/core/error/failures.dart';
import 'package:number_trivia_tutorial/core/usecases/usecase.dart';
import 'package:number_trivia_tutorial/core/utils/input_converter.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/presentation/bloc/bloc.dart';


class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}


void main() {

  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty ', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNUmber', () {

    final numberString = '1';
    final numberParsed = 1;
    final numberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should call the InputConverter to validate and convert string to unsigned integer',
      () async {
        when(mockInputConverter.stringToUnsignedInterger(any))
        .thenReturn(Right(numberParsed));

        bloc.dispatch(GetTriviaForConcreteNumber(numberString));

        await untilCalled(mockInputConverter.stringToUnsignedInterger(any));
        verify(mockInputConverter.stringToUnsignedInterger(numberString));
      },
    );

    test(
      'should emit Error state when the input is invalid',
      () async {
        when(mockInputConverter.stringToUnsignedInterger(any))
        .thenReturn(Left(InvalidInputFailure()));

        final expectedEvents = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
        expectLater(bloc.state, emitsInOrder(expectedEvents));

        bloc.dispatch(GetTriviaForConcreteNumber(numberString));

      },
    );


  });

}
