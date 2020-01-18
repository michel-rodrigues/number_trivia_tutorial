import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_trivia_tutorial/core/error/exceptions.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';


abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';


class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString == null) throw CacheException();

    final numberTrivia = NumberTriviaModel.fromJson(convert.jsonDecode(jsonString));
    return Future.value(numberTrivia);
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      convert.jsonEncode(triviaToCache.toJson())
    );
  }

}
