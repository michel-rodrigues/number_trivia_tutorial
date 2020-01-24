import 'package:equatable/equatable.dart'; // altera a operação de igualdade de endereço
                                           // na memória para igualdade de valores do objeto
import 'package:meta/meta.dart';


class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({
    @required this.text,
    @required this.number,
  }) : super(); // nesse contexto, o array dentro do super diz para
                              // o equatable quais atributos usar na comparação

  String toString() => 'number: $number - text: $text';

  @override
  List<Object> get props => [text, number];

}
