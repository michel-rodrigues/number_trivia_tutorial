import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';


void main() {
  final numberTriviaModel = NumberTriviaModel(number: 1, text: 'Testing trivia');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model when the JSON number is integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      expect(NumberTriviaModel.fromJson(jsonMap), numberTriviaModel);
    });
    test('should return valid model when the JSON number is regarded as a double', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
      expect(NumberTriviaModel.fromJson(jsonMap), numberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = numberTriviaModel.toJson();
      expect(result, {'number': 1, 'text': 'Testing trivia'});
    });
  });

}
