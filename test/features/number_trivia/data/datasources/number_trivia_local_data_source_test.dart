import 'dart:convert' as convert;
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_tutorial/core/error/exceptions.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}


void main() {

  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {

    final triviaCached = convert.jsonDecode(fixture('trivia_cached.json'));
    final numberTriviaModel = NumberTriviaModel.fromJson(triviaCached);

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        when(mockSharedPreferences.getString(any))
        .thenReturn(fixture('trivia_cached.json'));

        final result = await dataSource.getLastNumberTrivia();

        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is no cached value',
      () async {
        when(mockSharedPreferences.getString(any))
        .thenReturn(null);

        final call = dataSource.getLastNumberTrivia;

        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );

  });

  group('cacheNumberTrivia', () {

    final numberTriviaModel = NumberTriviaModel(number: 1, text: 'text trivia');

    test(
      'should call SharedPreferences to cache data',
      () async {
        dataSource.cacheNumberTrivia(numberTriviaModel);
        final expectedJsonString = convert.jsonEncode(numberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );

  });


}
