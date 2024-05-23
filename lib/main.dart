import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'pages/difficulty_page.dart';
import 'utils/json_parser.dart';
import 'pages/list_page.dart';
import 'pages/challenge_page.dart';
import 'pages/new_game_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/list': (context) => ListaPage(),
        '/difficulty': (context) =>
            DifficultyPage(), // Aggiunta la route per la pagina di selezione della difficoltà
        '/challenge': (context) => ChallengePage(),
        '/new_game': (context) => NewGamePage(),
      },
    );
  }
}
