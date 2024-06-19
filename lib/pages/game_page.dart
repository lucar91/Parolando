import 'package:flutter/material.dart';
import 'package:parolando/utils/json_parser.dart'; // Assicurati di importare il file json_parser.dart
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

  int score = 0; // Aggiunta la variabile score
  bool isLoading = true; // Aggiungi una variabile di stato per il caricamento
  final String difficultyLevel = 'Difficoltà'; // Livello di difficoltà

  late TimerManager _timerManager;
  late FocusNode _textFocusNode;

  List<String> availableLetters = [];
  List<String> usedLetters = [];
  Map<int, String> initialWords = {};

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    // Richiedi il focus sulla text area all'avvio del widget
    _updateFocus();
    loadJsonData(); // Carica i dati JSON all'avvio
    selectedIndex = 0;
    _timerManager = TimerManager(300,
        onTimerUpdate: _onTimerUpdate, onTimeExpired: _onTimeExpired);
    _timerManager.startTimer();
  }

  @override
  void dispose() {
    _timerManager
        .cancelTimer(); // Ferma il timer quando il widget viene smontato
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onTimerUpdate(int timeRemaining) {
    setState(() {
      // Questo viene chiamato ogni secondo per aggiornare il timer
    });
  }

  void _onTimeExpired() {
    _showPopup('Tempo scaduto!');
  }

  Future<void> loadJsonData() async {
    JsonParser jsonParser = JsonParser();
    try {
      await jsonParser.loadJsonData(); // Carica i dati JSON
      Map<String, dynamic>? wordsPack = jsonParser.getLevelItems(
          'easy', 1); // Ottieni le parole per il livello facile
      if (wordsPack != null) {
        Map<String, dynamic> wordsMap = wordsPack['words'];
        levelWords = wordsMap.keys.toList(); // Lista delle chiavi
        levelWordsLetters =
            wordsMap.values.map((value) => value.toString()).toList();
        disableRow = List<bool>.filled(levelWords!.length, false);
        setState(() {
          items =
              generateItems(); // Genera gli elementi in base ai dati del JSON
          isLoading =
              false; // Imposta isLoading su false dopo il caricamento dei dati
        });
        updateAvailableLetters();
      } else {
        throw Exception("Failed to get words for the level.");
      }
    } catch (e) {
      print("Error loading JSON data: $e");
      setState(() {
        isLoading =
            false; // Anche in caso di errore, impostiamo isLoading su false
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
    // Se c'è almeno una riga selezionata, richiedi il focus sulla text area
    if (selectedIndex != null) {
      _textFocusNode.requestFocus();
    } else {
      // Altrimenti, rimuovi il focus dalla text area
      _textFocusNode.unfocus();
    }
  }

  @override
  void didUpdateWidget(covariant GamePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Aggiorna il focus quando cambia lo stato delle righe selezionate
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
          color: Colors.blue, // Imposta il colore di sfondo blu
          child:
              isLoading // Mostra una schermata di caricamento se isLoading è true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
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
                                final isSelected = index ==
                                    selectedIndex; // Check if this is the selected index

                                return Padding(
                                  padding: const EdgeInsets.all(
                                      8.0), // Spazio intorno al riquadro
                                  child: InkWell(
                                    onTap: () {
                                      // Ignora l'azione se l'elemento è disabilitato
                                      if (disableRow[index]) {
                                        return;
                                      }
                                      setState(() {
                                        selectedIndex = index;
                                        _updateFocus();
                                        updateAvailableLetters();
                                      });
                                    },
                                    child: Container(
                                      color: isSelected
                                          ? Color(0xb94bd8ff)
                                          : Colors
                                              .transparent, // Imposta il colore di sfondo se selezionato
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: item.split('').map((char) {
                                          if (char != ' ') {
                                            return Container(
                                              width:
                                                  boxWidth, // Adatta la larghezza in base alla lunghezza massima
                                              height:
                                                  50, // Imposta l'altezza fissa del riquadro bianco
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      4), // Aggiunge spazio tra le caselle della stessa riga
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
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                  ),
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                  'Punteggio: $score', // Mostra il punteggio
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  _timerManager.getFormattedTime(), // Mostra il timer
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
                  // Vai al livello successivo
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
    // Pulisce la text area prima di mostrare il popup del punteggio
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

    // Rimuove il popup dopo un breve periodo di tempo
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

    // Continua a cercare la prossima riga abilitata
    while (disableRow[nextIndex % items.length]) {
      nextIndex++;
    }

    return nextIndex % items.length;
  }
}
