import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/api/firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/difficulty_page.dart';
import 'pages/game_page.dart';
import 'pages/challenge_page.dart';
import 'pages/new_game_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/home_page': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/list': (context) => GamePage(gameId: '0', isPlayer2: false),
        '/difficulty': (context) => DifficultyPage(),
        '/challenge': (context) => ChallengePage(),
        '/new_game': (context) => NewGamePage(),
      },
    );
  }
}
