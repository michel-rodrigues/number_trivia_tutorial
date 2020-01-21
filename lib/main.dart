import 'package:flutter/material.dart';
import 'injection_container.dart' as injector;
import 'package:number_trivia_tutorial/features/number_trivia/presentation/pages/number_trivia_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injector.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumberTrivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}
