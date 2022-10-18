import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.savedWord});

  final Set<WordPair> savedWord;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _crossWidget(WordPair pair) {
    final isAlreadySaved = widget.savedWord.contains(pair);
    return IconButton(
      icon: Icon(
        Icons.close,
        color: isAlreadySaved ? Colors.red : null,
      ),
      onPressed: () {
        setState(
          () {
            widget.savedWord.remove(pair);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<ListTile> tiles = widget.savedWord.map(
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
