import 'package:flutter/material.dart';

import 'dart:math';

import 'balle.dart';
import 'batte.dart';

enum Direction { haut, bas, gauche, droite }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double largeur = 400;
  double hauteur = 400;
  double posX = 0;
  double posY = 0;
  double largeurBatte = 0;
  double hauteurBatte = 0;
  double positionBatte = 0;
  Direction vDir = Direction.bas;
  Direction hDir = Direction.droite;
  late Animation<double> animation;
  late AnimationController controleur;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controleur = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controleur);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.droite)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.bas)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      testerBordures();
    });

    controleur.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      hauteur = constraints.maxHeight;
      largeur = constraints.maxWidth;
      largeurBatte = largeur / 5;
      hauteurBatte = hauteur / 20;

      return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 24,
            child: Text('Score : ' + score.toString()),
          ),
          Positioned(
            child: Balle(),
            top: posY,
            left: posX,
          ),
          Positioned(
              bottom: 0,
              left: positionBatte,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails maj) =>
                      deplacerBatte(maj, context),
                  child: Batte(largeurBatte, hauteurBatte))),
        ],
      );
    });
  }

  void testerBordures() {
    if (posX <= 0 && hDir == Direction.gauche) {
      hDir = Direction.droite;
      randX = nombreAleatoire();
    }
    if (posX >= largeur - Balle.diametre && hDir == Direction.droite) {
      hDir = Direction.gauche;
      randX = nombreAleatoire();
    }
    if (posY >= hauteur - Balle.diametre - hauteurBatte &&
        vDir == Direction.bas) {
      if (posX >= (positionBatte - Balle.diametre) &&
          posX <= (positionBatte + largeurBatte + Balle.diametre)) {
        vDir = Direction.haut;
        randY = nombreAleatoire();
        safeSetState(() {
          score++;
        });
      } else {
        controleur.stop();
        afficherMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.haut) {
      vDir = Direction.bas;
      randX = nombreAleatoire();
    }
  }

  void deplacerBatte(DragUpdateDetails maj, BuildContext context) {
    safeSetState(() {
      positionBatte += maj.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controleur.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double nombreAleatoire() {
    var alea = new Random();
    int monNombre = alea.nextInt(100);
    return (50 + monNombre) / 100;
  }

  void afficherMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Fin du jeu'),
            content: Text('Voulez vous faire une autre partie ?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Oui'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controleur.repeat();
                },
              ),
              ElevatedButton(
                child: const Text('Non'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );
        });
  }
}
