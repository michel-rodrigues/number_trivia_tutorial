import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';


class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}


void main() {

  GetConcreteNumberTrivia getConcreteNumberTrivia;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final number = 1;
  final numberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
    .thenAnswer((_) async => Right(numberTrivia));

    final result = await getConcreteNumberTrivia(Params(number: number));

    expect(result, Right(numberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(number));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

}
