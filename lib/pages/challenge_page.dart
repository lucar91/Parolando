import 'package:flutter/material.dart';
import 'game_page.dart';

class ChallengePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sfida'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/new_game');
              },
              child: Text('Nuova Partita'),
            ),
            ElevatedButton(
              onPressed: () {
                _showExistingGameDialog(context);
              },
              child: Text('Partita Esistente'),
            ),
          ],
        ),
      ),
    );
  }

  void _showExistingGameDialog(BuildContext context) {
    final TextEditingController _gameIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inserisci ID Partita'),
          content: TextField(
            controller: _gameIdController,
            decoration: InputDecoration(
              labelText: 'ID della Partita',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                String gameId = _gameIdController.text.trim();
                if (gameId.isNotEmpty) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        GamePage(gameId: gameId, isPlayer2: true),
                  ));
                }
              },
              child: Text('Gioca'),
            ),
          ],
        );
      },
    );
  }
}
