import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_tutorial/core/error/exceptions.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';


abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}


const NUMBERS_API_URL = 'http://numbersapi.com';


class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({@required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
    _getTrivia('$NUMBERS_API_URL/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTrivia('$NUMBERS_API_URL/random');

  Future<NumberTriviaModel> _getTrivia(url) async {
    final response = await httpClient.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) throw ServerException();
    return NumberTriviaModel.fromJson(convert.jsonDecode(response.body));
  }

}
