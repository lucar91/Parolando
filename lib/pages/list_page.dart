import 'package:flutter/material.dart';
import 'package:parolando/utils/json_parser.dart'; // Assicurati di importare il file json_parser.dart
import 'dart:async';

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  late List<String> items = [];
  late List<bool> disableRow = [];
  int? selectedIndex;
  TextEditingController _textEditingController = TextEditingController();

  List<String>? levelWords;

  int score = 0; // Aggiunta la variabile score

  @override
  void initState() {
    super.initState();
    loadJsonData(); // Carica i dati JSON all'avvio
  }

  Future<void> loadJsonData() async {
    JsonParser jsonParser = JsonParser();
    try {
      await jsonParser.loadJsonData(); // Carica i dati JSON
      Map<String, dynamic>? words = jsonParser.getWords(
          'easy', 1); // Ottieni le parole per il livello facile
      if (words != null) {
        levelWords = words['object'].keys.toList();

        disableRow = List<bool>.filled(levelWords!.length, false);
        items = generateItems(); // Genera gli elementi in base ai dati del JSON
        setState(() {
          // Inizializza il resto del tuo stato
          items =
              generateItems(); // Genera gli elementi in base ai dati del JSON
        });
      } else {
        throw Exception("Failed to get words for the level.");
      }
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  List<String> generateItems() {
    final List<String> result = [];
    for (int i = 0; i < levelWords!.length; i++) {
      final String word = levelWords![i];
      final String dashes = ''.padRight(word.length, '_ ');
      result.add('$dashes');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gioca'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Ignora l'azione se l'elemento è disabilitato
                    if (disableRow[index]) {
                      print("Forse qui");
                      return;
                    }
                    setState(() {
                      selectedIndex = index;
                      _textEditingController.text = '';
                    });
                  },
                  child: Container(
                    color: selectedIndex == index
                        ? Colors.yellow
                        : disableRow[index]
                            ? Colors.green
                            : Colors.white,
                    child: ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: (value) {
                      _checkWord(selectedIndex, replacement: value);
                    },
                    decoration: InputDecoration(
                      hintText: selectedIndex != null
                          ? '${items[selectedIndex!].length / 2} letters'
                          : 'Modifica la parola',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _checkWord(selectedIndex,
                        replacement: _textEditingController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Punteggio: $score', // Mostra il punteggio
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Livello ${getCurrentLevel()}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
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

  int getCurrentLevel() {
    // Implementa la logica per ottenere il numero del livello corrente
    return 1;
  }

  void _showScorePopup(int points) {
    // Pulisce la text area prima di mostrare il popup del punteggio
    _textEditingController.clear();

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

  bool _checkWord(int? index, {String? replacement}) {
    if (index != null && index >= 0 && index < items.length) {
      final List<String> words = levelWords!;

      final isWordInList = replacement != null &&
          words[index].toLowerCase() == replacement.toLowerCase();
      print('Ecco $replacement e ${words[index]} e $selectedIndex');
      setState(() {
        if (isWordInList) {
          score += items[index].length;
          items[index] = replacement!;
          selectedIndex = getNextIndex(index);
          disableRow[index] = true;
          _showScorePopup(items[index].length);
          if (disableRow.every((element) => element)) {
            _showPopup('Completato');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Riprova'),
              duration: Duration(seconds: 1), // Durata del popup: 1 secondo
            ),
          );
          selectedIndex = index;
        }
      });

      // Pulisce la text area e chiude il popup dopo un certo intervallo di tempo
      Timer(Duration(seconds: 2), () {
        setState(() {
          _textEditingController.clear();
        });
      });

      return isWordInList;
    }
    return false;
  }

  int getNextIndex(int currentIndex) {
    final nextIndex = currentIndex + 1;
    if (nextIndex >= items.length) {
      return 0;
    } else {
      return nextIndex;
    }
  }
}
