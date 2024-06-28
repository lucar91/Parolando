import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'game_page.dart'; // Assicurati di importare GamePage

class NewGamePage extends StatefulWidget {
  @override
  _NewGamePageState createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  String _selectedDifficulty = 'Facile';
  final TextEditingController _gameNameController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String? gameId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuova Partita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _gameNameController,
              decoration: InputDecoration(
                labelText: 'Nome della Partita',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDifficulty = newValue!;
                });
              },
              items: <String>['Facile', 'Medio', 'Difficile']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Difficoltà',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGame,
              child: Text('Crea Partita'),
            ),
          ],
        ),
      ),
    );
  }

  void _createGame() async {
    String gameName = _gameNameController.text.trim();
    if (gameName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inserisci un nome per la partita')),
      );
      return;
    }

    // Genera un ID univoco per la partita
    gameId = Uuid().v4();

    // Crea un nodo per la nuova partita nel database
    await _databaseReference.child('games/$gameId').set({
      'gameName': gameName,
      'currentWords': ['casa', 'gatto', 'cielo'],
      'duration': 60,
      'player1': {
        'name': 'Player1',
        'score': 0,
      },
      'player2': {
        'name': 'Player2',
        'score': 0,
      },
      'startTime': DateTime.now().toIso8601String(),
    });

    setState(() {});

    _showGameDialog();
  }

  void _showGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Partita Creata'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID della partita: $gameId'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GamePage(gameId: gameId!, isPlayer2: false),
                ));
              },
              child: Text('Gioca'),
            ),
          ],
        );
      },
    );
  }
}
