import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

final _savedWordPairs = Set<WordPair>();

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, item) {
        if (item.isOdd) return const Divider();

        final index = item ~/ 2; //no divider
        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(1));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final isAlreadySaved = _savedWordPairs.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        isAlreadySaved ? Icons.favorite : Icons.favorite_border,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(
          () {
            if (isAlreadySaved) {
              _savedWordPairs.remove(pair);
            } else {
              _savedWordPairs.add(pair);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Generator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailPage(),
                ),
              );
              setState(() => {});
            },
          ),
        ],
      ),
      body: Center(
        child: _buildList(),
      ),
    );
  }
}

// add a new stateful page
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _crossWidget(WordPair pair) {
    final isAlreadySaved = _savedWordPairs.contains(pair);
    return IconButton(
      icon: Icon(
        Icons.close,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onPressed: () {
        setState(
          () {
            _savedWordPairs.remove(pair);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<ListTile> tiles = _savedWordPairs.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: _crossWidget(pair),
        );
      },
    );

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }
}
