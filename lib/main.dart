import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

// This widget, ```StatelessWidget``` houses the whole app. It is from this widget
// the application is built. Also, in flutter a StatelessWidget like the name suggests
// is a widget which has no state within. Thus, they are immutable widgets and hence their properties
// can not change. All values are final
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backwardsCompatibility: false,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black)),
              
      home: RandomWords(),
    );
  }
}

// This class/widget is a stateful widget. Stateful widgets are able to maintain state
// that are likely to change during the lifecycle of the widget. When creating a stateful widget,
// two classes are required, the stateful widget itself and instance of the state class that stateful widget
// creates
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final wordPair = WordPair.random();
  final _suggestions = <WordPair>[]; // this is a list in dart
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{}; // this is a set in dart

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int iterator) {
        if (iterator.isOdd) {
          return Divider();
        }

        final int index = iterator ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair wordPair) {
    // subtle check to see if the particular list item has already been saved as afavorite
    final alreadySaved = _saved.contains(wordPair);

    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
              icon: const Icon(Icons.list))
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((wordPair) {
        return ListTile(
          title: Text(
            wordPair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });

      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(tiles: tiles, context: context).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(title: const Text('Saved Suggestions')),
        body: ListView(children: divided),
      );
    }));
  }
}
