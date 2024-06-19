import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/difficulty_page.dart';
import 'pages/game_page.dart';
import 'pages/challenge_page.dart';
import 'pages/new_game_page.dart';
import 'pages/login_page.dart'; // Aggiungi questa riga per importare LoginPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Imposta LoginPage come la schermata iniziale
      routes: {
        '/home_page': (context) => HomePage(),
        '/login': (context) =>
            LoginPage(), // Aggiungi questa riga per la route di LoginPage
        '/list': (context) => GamePage(),
        '/difficulty': (context) => DifficultyPage(),
        '/challenge': (context) => ChallengePage(),
        '/new_game': (context) => NewGamePage(),
      },
    );
  }
}
