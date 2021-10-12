import 'package:flutter/material.dart';
import 'package:tp3_jouons_a_pong/pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Jeu Pong',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Jeu Pong'),
            ),
            body: Pong()));
  }
}
