import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:number_trivia_tutorial/core/error/failures.dart';
import 'package:number_trivia_tutorial/core/plataform/network_info.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/repositories/number_trivia_repository.dart';


class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  NumberTriviaRemoteDataSource remoteDataSource;
  NumberTriviaLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {}

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {}
}
