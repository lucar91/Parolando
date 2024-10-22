import 'package:flutter/material.dart';

class TrainingDifficultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleziona la Difficoltà'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.lightBlue[100], // Colore di sfondo blu chiaro
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.lightbulb),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
                label: Text('Facile'),
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
                icon: Icon(Icons.assessment),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
                label: Text('Medio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.flash_on),
                onPressed: () {
                  Navigator.pushNamed(context, '/game');
                },
                label: Text('Difficile'),
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
          ),
        ),
      ),
    );
  }
}
