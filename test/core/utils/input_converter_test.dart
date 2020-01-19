import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_tutorial/core/utils/input_converter.dart';


void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInterger', () {
    test('should return an integer when the string represents an unsigned integer', () async {
        final result = inputConverter.stringToUnsignedInterger('123');
        expect(result, Right(123));
      },
    );

    test('should return Failure when the string is not an integer', () async {
        final result = inputConverter.stringToUnsignedInterger('abc123');
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test('should return Failure when the string is a negative integer', () async {
        final result = inputConverter.stringToUnsignedInterger('-123');
        expect(result, Left(InvalidInputFailure()));
      },
    );


  });

}
