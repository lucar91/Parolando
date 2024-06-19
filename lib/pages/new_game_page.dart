import 'package:flutter/material.dart';

class NewGamePage extends StatefulWidget {
  @override
  _NewGamePageState createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  String _selectedDifficulty = 'Facile';
  final TextEditingController _gameNameController = TextEditingController();

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
              onPressed: () {
                // Implementa la logica per invitare qualcuno
              },
              child: Text('Invita qualcuno'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementa la logica per creare una nuova partita con i dettagli selezionati
              },
              child: Text('Crea Partita'),
            ),
          ],
        ),
      ),
    );
  }
}
