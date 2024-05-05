import 'package:flutter/material.dart';

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
                Navigator.pushNamed(context, '/lista');
              },
              child: Text('Apri la lista'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Qui puoi gestire la seconda scelta
              },
              child: Text('Seconda scelta'),
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
  late List<String> items;
  int? selectedIndex;
  TextEditingController _textEditingController = TextEditingController();

  late List<dynamic> arrayInformazioni; // Dichiarazione di arrayInformazioni
  late List<bool> disableRow; // Dichiarazione di disableRow
  int score = 0; // Punteggio iniziale

  @override
  void initState() {
    super.initState();
    arrayInformazioni = [
      5,
      ['G', 'a', 't', 'o', 'l', 'b', 'e', 'r', 'c', 'i', 's'],
      ['Gatto', 'Albero', 'Cielo', 'Libro', 'Cascata']
    ];
    items = generateItems();
    disableRow = List<bool>.filled(
        arrayInformazioni[2].length, false); // Inizializzazione di disableRow
  }

  List<String> generateItems() {
    final List<String> words = List<String>.from(arrayInformazioni[2]);

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
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Sei sicuro di voler uscire?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Sì'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gioca'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Punteggio: $score'),
                  Text('Livello ${getCurrentLevel()}'),
                ],
              ),
            ),
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
                      decoration: InputDecoration(
                        hintText: selectedIndex != null
                            ? '${items[selectedIndex!].length / 2} letters'
                            : 'Modifica la parola',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _checkWord(selectedIndex,
                          insertedWord: _textEditingController.text);
                    },
                    child: Text('Ok'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkWord(int? index, {String? insertedWord}) {
    if (index != null && index >= 0 && index < items.length) {
      final currentWord = arrayInformazioni[2][index];
      final isWordInList = insertedWord != null && currentWord == insertedWord;
      print('Ecco $insertedWord e $currentWord e $selectedIndex');
      setState(() {
        if (isWordInList) {
          score += items[index].length; // Incrementa il punteggio
          items[index] = insertedWord!;
          selectedIndex = getNextIndex(index); // Passa all'indice successivo
          disableRow[index] = true; // Imposta l'elemento come disabilitato
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Perfetto'),
              duration: Duration(seconds: 1), // Durata del popup: 1 secondo
            ),
          );
          // Verifica se tutte le parole sono disabilitate
          if (disableRow.every((element) => element)) {
            // Mostra il messaggio "Livello Completato"
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Livello Completato'),
                duration: Duration(seconds: 1), // Durata del popup: 1 secondo
              ),
            );
            selectedIndex = null; // Resetta selectedIndex a null
          }
        } else {
          // Mostra il messaggio di errore come SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Riprova'),
              duration: Duration(seconds: 1), // Durata del popup: 1 secondo
            ),
          );
          // Non passare all'indice successivo
        }
        _textEditingController
            .clear(); // Svuota il contenuto della casella di testo
      });

      return isWordInList;
    }
    return false;
  }

  int getCurrentLevel() {
    // La funzione per ottenere il livello corrente qui
    return 1; // Esempio di livello fisso (da modificare)
  }

  int getNextIndex(int currentIndex) {
    final nextIndex = currentIndex + 1;
    if (nextIndex >= items.length) {
      return 0; // Torna all'inizio se l'indice successivo supera la lunghezza dell'array
    } else {
      // Controlla se l'elemento successivo è già disabilitato
      if (disableRow[nextIndex]) {
        return getNextIndex(
            nextIndex); // Cerca l'indice successivo non disabilitato
      } else {
        return nextIndex;
      }
    }
  }
}
