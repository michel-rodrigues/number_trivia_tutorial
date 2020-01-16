import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_tutorial/core/usecases/usecase.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';


class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}


void main() {

  GetRandomNumberTrivia getRandomNumberTrivia;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTrivia = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  final numberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
    .thenAnswer((_) async => Right(numberTrivia));

    final result = await getRandomNumberTrivia(NoParams());

    expect(result, Right(numberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

}
