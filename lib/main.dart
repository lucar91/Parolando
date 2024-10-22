import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Aggiungi questo import
import 'pages/api/firebase_options.dart';
import 'pages/main_menu_page.dart';
import 'pages/gameHandler/training_difficulty_page.dart';
import 'pages/gameHandler/game_page.dart';
import 'pages/gameHandler/challenge_mode_page.dart';
import 'pages/gameHandler/new_challenge_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Controlla se l'utente è loggato
  final prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  // Costruttore per ricevere lo stato del login
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Imposta la route iniziale in base allo stato di login
      initialRoute: isLoggedIn ? '/home_page' : '/login',
      routes: {
        '/home_page': (context) => MainMenuPage(),
        '/login': (context) => LoginPage(),
        '/game': (context) => GamePage(gameId: '0', isPlayer2: false),
        '/training': (context) => TrainingDifficultyPage(),
        '/challenge': (context) => ChallengeModePage(),
        '/new_game': (context) => NewChallengePage(),
      },
    );
  }
}
