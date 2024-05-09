import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // Implementa la logica per il login
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/difficulty');
              },
              child: Text('Allenamento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Qui puoi gestire la seconda scelta
              },
              child: Text('Sfida'),
            ),
          ],
        ),
      ),
    );
  }
}
