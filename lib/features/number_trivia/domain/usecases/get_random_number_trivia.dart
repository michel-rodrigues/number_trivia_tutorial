import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:number_trivia_tutorial/core/error/failures.dart';
import 'package:number_trivia_tutorial/core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';


class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
