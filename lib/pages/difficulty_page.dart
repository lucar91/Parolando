import 'package:flutter/material.dart';

class DifficultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleziona la Difficoltà'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/list'); // Naviga alla pagina di gioco
              },
              child: Text('Facile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/list'); // Naviga alla pagina di gioco
              },
              child: Text('Medio'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/list'); // Naviga alla pagina di gioco
              },
              child: Text('Difficile'),
            ),
          ],
        ),
      ),
    );
  }
}
