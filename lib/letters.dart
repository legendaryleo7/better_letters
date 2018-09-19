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

  @override
  void initState() {
    super.initState();

    // Start listening to changes
    this.oldMessageText.addListener(_updateNeededLetters);
    this.newMessageText.addListener(_updateNeededLetters);
    this.numberOfSides.addListener(_updateNeededLetters);
  }

  void _updateNeededLetters() {
    setState(() {
      calculateLetter();
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = new Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new TextField(
            controller: this.oldMessageText,
            decoration: new InputDecoration(hintText: "Old message"),
          ),
          new Padding(padding: EdgeInsets.only(top: 25.0)),
          new TextField(
            controller: this.newMessageText,
            decoration: new InputDecoration(hintText: "New message"),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 25.0),
          ),
          new TextField(
              controller: this.numberOfSides,
              decoration: new InputDecoration(hintText: "Number of sides"),
              keyboardType: TextInputType.numberWithOptions()),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Better Letters"),
      ),
      body: ListView(children: <Widget>[
        box,
        new ListView.builder(
          itemCount: this.neededLetters.length,
          itemBuilder: (context, index) {
            var key = this.neededLetters.keys.elementAt(index);
            var value = this.neededLetters[key];
            return ListTile(
              title: Text('$key - $value needed.'),
            );
          },
          shrinkWrap: true,
        ),
      ]),
    );
  }

  @override
  void dispose() {
    this.newMessageText.removeListener(_updateNeededLetters);
    this.oldMessageText.removeListener(_updateNeededLetters);
    this.numberOfSides.removeListener(_updateNeededLetters);

    this.newMessageText.dispose();
    this.oldMessageText.dispose();
    this.numberOfSides.dispose();
    super.dispose();
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
        var neededCount = (newMap[key] - existingCount) * numberOfSides;
        
        if (neededCount > 0) {
          this.neededLetters[key] = neededCount;
        }
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
