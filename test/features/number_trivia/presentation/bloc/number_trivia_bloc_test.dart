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

  group('GetTriviaForConcreteNumber', () {

    final numberString = '1';
    final numberParsed = 1;
    final numberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
      when(mockInputConverter.stringToUnsignedInterger(any))
      .thenReturn(Right(numberParsed));

    test(
      'should call the InputConverter to validate and convert string to unsigned integer',
      () async {
        setUpMockInputConverterSuccess();
        bloc.add(GetTriviaForConcreteNumber(numberString));

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
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForConcreteNumber(numberString));

      },
    );

    test(
      'should get data from the concrete usecase',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));

        bloc.add(GetTriviaForConcreteNumber(numberString));

        await untilCalled(mockGetConcreteNumberTrivia(any));
        verify(mockGetConcreteNumberTrivia(Params(number: numberParsed)));
      },
    );

    test(
      'should emit Loading and Loaded when data is gotten successfully',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));

        final expectedEvents = [Empty(), Loading(), Loaded(trivia: numberTrivia)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForConcreteNumber(numberString));

      },
    );

    test(
      'should emit Loading and Error when getting data fails',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

        final expectedEvents = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForConcreteNumber(numberString));

      },
    );

    test(
      'should emit Loading and Error whith proper error message when getting data fails',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));

        final expectedEvents = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForConcreteNumber(numberString));

      },
    );

  });

  group('GetTriviaForRandomNumber', () {

    final numberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random usecase',
      () async {

        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));

        bloc.add(GetTriviaForRandomNumber());

        await untilCalled(mockGetRandomNumberTrivia(NoParams()));
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit Loading and Loaded when data is gotten successfully',
      () async {

        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));

        final expectedEvents = [Empty(), Loading(), Loaded(trivia: numberTrivia)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForRandomNumber());

      },
    );

    test(
      'should emit Loading and Error when getting data fails',
      () async {

        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

        final expectedEvents = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForRandomNumber());

      },
    );

    test(
      'should emit Loading and Error whith proper error message when getting data fails',
      () async {

        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(CacheFailure()));

        final expectedEvents = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expectedEvents));

        bloc.add(GetTriviaForRandomNumber());

      },
    );

  });


}
