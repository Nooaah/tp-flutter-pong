import 'package:flutter/material.dart';

class Balle extends StatelessWidget {
  const Balle({Key? key}) : super(key: key);

  static double diametre = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametre,
      height: diametre,
      decoration: new BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle,
      ),
    );
  }
}
