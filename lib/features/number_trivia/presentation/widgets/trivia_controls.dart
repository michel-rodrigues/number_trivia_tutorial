import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_tutorial/features/number_trivia/presentation/bloc/bloc.dart';


class TriviaControls extends StatefulWidget {
  const TriviaControls({Key key}) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();

}


class _TriviaControlsState extends State<TriviaControls> {

  String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column( // Botton half
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number'
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => dispatchConcrete(),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                textTheme: ButtonTextTheme.primary,
                color: Theme.of(context).accentColor,
                onPressed: dispatchConcrete,
              )
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get Random trivia'),
                onPressed: dispatchRandom,
              )
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }

}
