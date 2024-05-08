import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/lista': (context) => ListaPage(),
        '/difficolta': (context) =>
            DifficoltaPage(), // Aggiunta la route per la pagina di selezione della difficoltà
      },
    );
  }
}

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
                Navigator.pushNamed(context,
                    '/difficolta'); // Naviga alla pagina di selezione della difficoltà
              },
              child: Text('Allenamento'), // Modifica il testo del pulsante
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Qui puoi gestire la seconda scelta
              },
              child: Text('Sfida'), // Modifica il testo del pulsante
            ),
          ],
        ),
      ),
    );
  }
}

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  late List<String> items = [];
  late List<bool> disableRow = [];
  int? selectedIndex;
  TextEditingController _textEditingController = TextEditingController();

  late Map<String, dynamic> levelWords;

  int score = 0; // Aggiunta la variabile score

  @override
  void initState() {
    super.initState();
    loadJsonData(); // Carica i dati JSON all'avvio
  }

  // Funzione per caricare i dati JSON
  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('resources/data.json');
    Map<String, dynamic> jsonContent = json.decode(jsonString);
    setState(() {
      // Inizializza levelWords utilizzando la parola chiave "object"
      levelWords = Map<String, dynamic>.from(
          jsonContent['easy']['level']['1']['object']);
      // Inizializza disableRow con false per ogni elemento in levelWords
      disableRow = List<bool>.filled(levelWords.length, false);
      // Inizializza il resto del tuo stato
      items = generateItems();
    });
  }

  // Funzione per generare gli elementi iniziali dalla lista JSON
  List<String> generateItems() {
    final List<String> words = levelWords.keys.toList();
    final List<String> result = [];
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
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
      final List<String> words = levelWords.keys.toList();

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

class DifficoltaPage extends StatelessWidget {
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
                    context, '/lista'); // Naviga alla pagina di gioco
              },
              child: Text('Facile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/lista'); // Naviga alla pagina di gioco
              },
              child: Text('Medio'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/lista'); // Naviga alla pagina di gioco
              },
              child: Text('Difficile'),
            ),
          ],
        ),
      ),
    );
  }
}
