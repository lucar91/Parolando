import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'timer_manager.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<String> items = [];
  late List<bool> disableRow = [];
  int? selectedIndex;

  List<String>? levelWords;
  List<String>? levelWordsLetters;

  int score = 0; // Added score variable
  bool isLoading = true; // Loading state variable
  final String difficultyLevel = 'Difficoltà'; // Difficulty level

  late TimerManager _timerManager;
  late FocusNode _textFocusNode;

  List<String> availableLetters = [];
  List<String> usedLetters = [];
  Map<int, String> initialWords = {};

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String gameId = "gameId1"; // Game ID, can be dynamic based on your needs.

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _updateFocus();
    loadGameData(); // Load game data from Firebase
    selectedIndex = 0;
    _timerManager = TimerManager(300,
        onTimerUpdate: _onTimerUpdate, onTimeExpired: _onTimeExpired);
    _timerManager.startTimer();
  }

  @override
  void dispose() {
    _timerManager.cancelTimer();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onTimerUpdate(int timeRemaining) {
    setState(() {
      // Update the timer
    });
  }

  void _onTimeExpired() {
    _showPopup('Tempo scaduto!');
  }

  Future<void> loadGameData() async {
    try {
      print('Reading data from Firebase...');
      DatabaseEvent event =
          await _databaseReference.child('games/$gameId').once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;
        print("Game data: $data");

        List<String> words = List<String>.from(data['currentWords']);
        List<String> wordsLetters =
            words.map((value) => value.toString()).toList();
        List<bool> disableRow = List<bool>.filled(words.length, false);

        setState(() {
          levelWords = words;
          levelWordsLetters = wordsLetters;
          this.disableRow = disableRow;
          items = generateItems();
          isLoading = false;
        });
        updateAvailableLetters();
      } else {
        throw Exception("Game document does not exist.");
      }
    } catch (e) {
      print("Error loading game data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateAvailableLetters() {
    if (selectedIndex != null && levelWords != null) {
      String word = levelWords![selectedIndex!];
      availableLetters = word.split('');
      print(availableLetters);
      availableLetters.removeAt(0);
      availableLetters.shuffle(Random());
    }
  }

  List<String> generateItems() {
    final List<String> result = [];
    for (int i = 0; i < levelWords!.length; i++) {
      final String word = levelWords![i];
      final String dashes = word[0].padRight(word.length, '_');
      initialWords[i] = dashes;
      result.add('$dashes');
    }
    return result;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sei sicuro di voler uscire?'),
            content: Text('La partita non verrà salvata.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Gioca'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Esci'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _updateFocus() {
    if (selectedIndex != null) {
      _textFocusNode.requestFocus();
    } else {
      _textFocusNode.unfocus();
    }
  }

  @override
  void didUpdateWidget(covariant GamePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateFocus();
  }

  @override
  Widget build(BuildContext context) {
    final maxWordLength = levelWords
            ?.map((word) => word.length)
            .reduce((a, b) => a > b ? a : b) ??
        1;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth =
        (screenWidth - 32 - (maxWordLength - 1) * 8) / maxWordLength;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$difficultyLevel - Livello 1'),
        ),
        body: Container(
          color: Colors.blue,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final isSelected = index == selectedIndex;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (disableRow[index]) return;
                                  setState(() {
                                    selectedIndex = index;
                                    _updateFocus();
                                    updateAvailableLetters();
                                  });
                                },
                                child: Container(
                                  color: isSelected
                                      ? Color(0xb94bd8ff)
                                      : Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: item.split('').map((char) {
                                      if (char != ' ') {
                                        return Container(
                                          width: boxWidth,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              char,
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox(width: 16);
                                      }
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: availableLetters.map((letter) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              _onLetterTap(letter);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                letter,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _resetSelectedWord,
                        child: Text('Clean'),
                      ),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Punteggio: $score',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  _timerManager.getFormattedTime(),
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (message == 'Completato') {
                  setState(() {
                    selectedIndex = null;
                  });
                }
              },
              child: Text('Chiudi'),
            ),
            if (message == 'Completato')
              ElevatedButton(
                onPressed: () {
                  // Go to the next level
                },
                child: Text('Livello Successivo'),
              ),
            if (message == 'Completato')
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('Home'),
              ),
          ],
        );
      },
    );
  }

  void _showScorePopup(int points) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.4,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              '+$points',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);

    Future.delayed(Duration(milliseconds: 800), () {
      overlayEntry.remove();
    });
  }

  void _onLetterTap(String letter) {
    if (selectedIndex == null) return;
    setState(() {
      usedLetters.add(letter);
      availableLetters.remove(letter);
      String currentItem = items[selectedIndex!];
      int firstUnderscore = currentItem.indexOf('_');
      if (firstUnderscore != -1) {
        currentItem = currentItem.replaceFirst('_', letter);
        items[selectedIndex!] = currentItem;
      }
      if (!currentItem.contains('_')) {
        _checkWord(selectedIndex, replacement: currentItem);
      }
    });
  }

  bool _checkWord(int? index, {String? replacement}) {
    if (index != null && index >= 0 && index < items.length) {
      final List<String> words = levelWords!;

      final isWordInList = replacement != null &&
          words[index].toLowerCase() == replacement.toLowerCase();
      setState(() {
        if (isWordInList) {
          score += items[index].length;
          items[index] = replacement.toUpperCase();
          selectedIndex = getNextIndex(index);
          disableRow[index] = true;
          _showScorePopup(items[index].length);
          if (disableRow.every((element) => element)) {
            _showPopup('Completato');
          }
          updateAvailableLetters();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Riprova'),
              duration: Duration(seconds: 1),
            ),
          );
          _resetSelectedWord();
        }
      });

      return isWordInList;
    }
    return false;
  }

  void _resetSelectedWord() {
    if (selectedIndex == null) return;
    setState(() {
      items[selectedIndex!] = initialWords[selectedIndex!]!;
      availableLetters.addAll(usedLetters);
      usedLetters.clear();
      availableLetters.shuffle(Random());
      updateAvailableLetters();
    });
  }

  int getNextIndex(int currentIndex) {
    int nextIndex = currentIndex + 1;

    while (disableRow[nextIndex % items.length]) {
      nextIndex++;
    }

    return nextIndex % items.length;
  }
}
