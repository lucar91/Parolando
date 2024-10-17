import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login(BuildContext context) async {
    print("login page");
    setState(() {
      isLoading = true;
    });
    String email = emailController.text;
    String password = passwordController.text;

    try {
      // Simulate login
      await Future.delayed(Duration(seconds: 2)); // Remove this in a real case

      // Perform Firebase database read
      await _testFirebaseRead();

      await _saveLoginSession(email);

      Navigator.pushReplacementNamed(
          context, '/home_page'); // Navigate to home page
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveLoginSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email); // Save the user's email
    await prefs.setBool(
        'is_logged_in', true); // Save a flag to indicate logged in state
    print("Session saved in SharedPreferences");
  }

  Future<void> _testFirebaseRead() async {
    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();
      print('Reading data from Firebase...');
      DatabaseEvent event =
          await databaseReference.child('games/gameId1').once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        print("Firebase data read successful: ${snapshot.value}");
      } else {
        print("No data found in Firebase for the specified query.");
      }
    } catch (e) {
      print("Error reading data from Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.amber, // Change button color
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 32),
                  Divider(color: Colors.white),
                ],
              ),
      ),
    );
  }
}
