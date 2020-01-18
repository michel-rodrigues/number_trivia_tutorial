import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_tutorial/core/error/exceptions.dart';
import 'package:number_trivia_tutorial/core/error/failures.dart';
import 'package:number_trivia_tutorial/core/network/network_info.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';


class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}


void main() {

  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

  });

  void runTestOnline(Function body) {
    group('device is online', () {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  };

  void runTestOffline(Function body) {
    group('device is offline', () {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  };

  group('getConcreteNumberTrivia', () {

    final number = 1;
    final numberTriviaModel = NumberTriviaModel(number: number, text: 'test trivia');
    final NumberTrivia numberTrivia = numberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(number);
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {

      test(
        'should return remote data when the call to remote data source is successful',
        () async {

          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(number);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          expect(result, equals(Right(numberTrivia)));
        }
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {

          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => numberTriviaModel);

          await repository.getConcreteNumberTrivia(number);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        }
      );

      test(
        'should return server failure data when the call to remote data source is unsuccessful',
        () async {

          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());

          final result = await repository.getConcreteNumberTrivia(number);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          verifyZeroInteractions(mockLocalDataSource);
          verifyNever(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
          expect(result, equals(Left(ServerFailure())));
        }
      );

    });

    runTestOffline(() {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(number);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        }
      );

      test(
        'should return cached failure when there is no cached data present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

          final result = await repository.getConcreteNumberTrivia(number);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
      );

    });

  });

  group('getRandomNumberTrivia', () {

    final numberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia numberTrivia = numberTriviaModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {

      test(
        'should return remote data when the call to remote data source is successful',
        () async {

          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        }
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {

          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => numberTriviaModel);

          await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        }
      );

      test(
        'should return server failure data when the call to remote data source is unsuccessful',
        () async {

          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());

          final result = await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          verifyNever(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
          expect(result, equals(Left(ServerFailure())));
        }
      );

    });

    runTestOffline(() {

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getRandomNumberTrivia();

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        }
      );

      test(
        'should return cached failure when there is no cached data present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

          final result = await repository.getRandomNumberTrivia();

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        }
      );

    });

  });

}
