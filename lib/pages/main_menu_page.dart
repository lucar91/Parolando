import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuPage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.setBool('is_logged_in', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people),
            SizedBox(width: 10),
            Text('AMICI'),
            SizedBox(width: 50), // Spazio tra "AMICI" e "OPZIONI"
            Icon(Icons.settings),
            SizedBox(width: 10),
            Text('OPZIONI'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue[100], // Colore di sfondo blu chiaro
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tasto Allenamento
              ElevatedButton.icon(
                icon: Icon(Icons.fitness_center),
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/training'); // Pagina per scegliere difficoltà
                },
                label: Text('Allenamento'),
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
              // Tasto Sfida
              ElevatedButton.icon(
                icon: Icon(Icons.sports_esports),
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/challenge'); // Pagina per sfidare un amico
                },
                label: Text('Sfida'),
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
