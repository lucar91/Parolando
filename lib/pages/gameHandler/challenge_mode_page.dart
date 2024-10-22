import 'package:flutter/material.dart';
import 'game_page.dart';

class ChallengeModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sfida'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.lightBlue[100], // Colore di sfondo blu chiaro
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/new_game');
              },
              label: Text('Nuova Partita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              onPressed: () {
                _showExistingGameDialog(context);
              },
              label: Text('Partita Esistente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        )),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}
