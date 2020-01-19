import 'dart:convert' as convert;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_tutorial/core/error/exceptions.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';


class MockHttpClient extends Mock implements http.Client {}



void main() {

  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  final triviaJson = fixture('trivia.json');

  void setUpMockHttpClientResponse(response) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
    .thenAnswer((_) async => response);
  };

  group('getConcreteNumberTrivia', () {

    final number = 1;
    final numberTriviaModel = NumberTriviaModel.fromJson(convert.jsonDecode(triviaJson));

    test(
      'should perform get request with number and application/json header',
      () async {
        setUpMockHttpClientResponse(http.Response(triviaJson, 200));
        dataSource.getConcreteNumberTrivia(number);
        verify(
          mockHttpClient.get(
            '$NUMBERS_API_URL/$number',
            headers: {'Content-Type': 'application/json'}
          )
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
      () async {
        setUpMockHttpClientResponse(http.Response(triviaJson, 200));
        final result = await dataSource.getConcreteNumberTrivia(number);
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw ServerException when the response is not 200',
      () async {
        setUpMockHttpClientResponse(http.Response('Not found', 404));
        final call = dataSource.getConcreteNumberTrivia;
        expect(() => call(number), throwsA(TypeMatcher<ServerException>()));

      },
    );

  });

  group('getRandomNumberTrivia', () {

    final numberTriviaModel = NumberTriviaModel.fromJson(convert.jsonDecode(triviaJson));

    test(
      'should perform get request with word random and application/json header',
      () async {
        setUpMockHttpClientResponse(http.Response(triviaJson, 200));
        dataSource.getRandomNumberTrivia();
        verify(
          mockHttpClient.get(
            '$NUMBERS_API_URL/random',
            headers: {'Content-Type': 'application/json'}
          )
        );
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
      () async {
        setUpMockHttpClientResponse(http.Response(triviaJson, 200));
        final result = await dataSource.getRandomNumberTrivia();
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw ServerException when the response is not 200',
      () async {
        setUpMockHttpClientResponse(http.Response('Not found', 404));
        final call = dataSource.getRandomNumberTrivia;
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));

      },
    );

  });

}
