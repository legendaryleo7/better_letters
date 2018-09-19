import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LettersWidget extends StatefulWidget {
  LettersWidget({Key key, this.oldMessage, this.newMessage, this.numberOfSides})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String oldMessage;
  final String newMessage;
  final int numberOfSides;

  @override
  _LettersState createState() => new _LettersState();
}

class _LettersState extends State<LettersWidget> {
  var oldMessageText = new TextEditingController();
  var newMessageText = new TextEditingController();
  var numberOfSides = new TextEditingController();
  var neededLetters = new Map<String, int>();

  void _incrementCounter() {
    setState(() {
      calculateLetter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.newMessage),
      ),
      body: ListView(children: <Widget>[
        new Column(
          children: <Widget>[
            new Text('Old message:', style: Theme.of(context).textTheme.body1),
            new TextField(controller: this.oldMessageText),
            new Text(
              'New message:',
              style: Theme.of(context).textTheme.body2,
            ),
            new TextField(controller: this.newMessageText),
            new Text('Number of sides on this sign:',
                style: Theme.of(context).textTheme.body2),
            new TextField(
                controller: this.numberOfSides,
                keyboardType: TextInputType.numberWithOptions()),
          ],
        ),
        new ListView.builder(
          itemCount: this.neededLetters.length,
          itemBuilder: (context, index) {
            var key = this.neededLetters.keys.elementAt(index);
            var value = this.neededLetters[key];
            if (value > 0) {
              return ListTile(
              title: Text('$key - $value needed.'),
            );
            }                   
          },
          shrinkWrap: true,
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }

  void calculateLetter() {
    var oldMap = convertStringToMap(this.oldMessageText.text);
    var newMap = convertStringToMap(this.newMessageText.text);
    var numberOfSides = int.tryParse(this.numberOfSides.text);
    numberOfSides ??= 2;

    this.neededLetters.clear();

    newMap.forEach((key, value) {
      if (oldMap.containsKey(key)) {
        var existingCount = oldMap[key];
        this.neededLetters[key] = (newMap[key] - existingCount) * numberOfSides;
      } else {
        this.neededLetters[key] = newMap[key] * numberOfSides;
      }
    });
  }

  Map<String, int> convertStringToMap(String string) {
    var map = new Map<String, int>();

    string
        .toUpperCase()
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
        .runes
        .forEach((int rune) {
      var character = new String.fromCharCode(rune);

      if (map.containsKey(character)) {
        var charCount = map[character];
        map[character] = charCount + 1;
      } else {
        map[character] = 1;
      }
    });

    return map;
  }
}
