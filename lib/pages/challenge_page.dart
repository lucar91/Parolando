import 'package:flutter/material.dart';

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
                // Implementa la logica per "Partita Esistente"
              },
              child: Text('Partita Esistente'),
            ),
          ],
        ),
      ),
    );
  }
}
