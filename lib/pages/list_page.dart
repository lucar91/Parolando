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
      Map<String, dynamic>? words = jsonParser.getLevelItems(
          'easy', 1); // Ottieni le parole per il livello facile
      if (words != null) {
        levelWords = words['object'].keys.toList();

        disableRow = List<bool>.filled(levelWords!.length, false);
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
      final String dashes = word[0].padRight(word.length, '_');

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
      body: Container(
        color: Colors.blue, // Imposta il colore di sfondo blu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    // Calcola la lunghezza massima della riga
                    final maxLength = item.replaceAll(' ', '').length;

                    return Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Spazio intorno al riquadro
                      child: InkWell(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: item.split('').map((char) {
                            if (char != ' ') {
                              return SizedBox(
                                width: 300 /
                                    maxLength, // Adatta la larghezza in base alla lunghezza massima
                                height:
                                    50, // Imposta l'altezza fissa del riquadro bianco
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Imposta il colore di sfondo del riquadro bianco
                                    borderRadius: BorderRadius.circular(
                                        8), // Arrotonda i bordi del riquadro
                                  ),
                                  alignment: Alignment
                                      .center, // Centra il testo all'interno del riquadro
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      char,
                                      style: TextStyle(
                                        fontSize:
                                            24, // Imposta la dimensione del testo
                                      ),
                                      maxLines:
                                          1, // Imposta il numero massimo di linee a 1
                                      overflow: TextOverflow
                                          .ellipsis, // Impedisce il testo di andare a capo
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                  width:
                                      16); // Aggiunge uno spazio tra i riquadri bianchi
                            }
                          }).toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus:
                          true, // Imposta il focus sulla text area di default
                      onSubmitted: (value) {
                        _checkWord(selectedIndex, replacement: value);
                      },
                      decoration: InputDecoration(
                        hintText: selectedIndex != null
                            ? '${items[selectedIndex!].length} letters'
                            : 'Modifica la parola',
                        border: OutlineInputBorder(),
                        fillColor: Colors
                            .white, // Imposta il colore di sfondo della text area
                        filled: true, // Assicura che la text area sia riempita
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
          items[index] = replacement.toUpperCase();
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
