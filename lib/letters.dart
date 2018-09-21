import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LettersWidget extends StatefulWidget {
  LettersWidget({Key key, this.oldMessage, this.newMessage, this.numberOfSides})
      : super(key: key);

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

  var newMessageFocusNode = new FocusNode();
  var numberOfSidesFocusNode = new FocusNode();

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
    var oldMessageTextField = new TextField(
      autofocus: true,
      controller: this.oldMessageText,
      decoration: new InputDecoration(hintText: "Old message"),
      onEditingComplete: () => FocusScope.of(context).requestFocus(this.newMessageFocusNode),
      textInputAction: TextInputAction.next,
    );

    var newMessageTextField = new TextField(
      controller: this.newMessageText,
      decoration: new InputDecoration(hintText: "New message"),
      focusNode: this.newMessageFocusNode,
      onEditingComplete: () => FocusScope.of(context).requestFocus(this.numberOfSidesFocusNode),
      textInputAction: TextInputAction.next,
    );

    var numberOfSidesTextField = new TextField(
        controller: this.numberOfSides,
        decoration: new InputDecoration(hintText: "Number of sides"),
        focusNode: this.numberOfSidesFocusNode,
        keyboardType: TextInputType.number,
        
        textInputAction: TextInputAction.done,
    );

    var padding = new Padding(padding: EdgeInsets.only(top: 25.0));

    var children = <Widget>[
          oldMessageTextField,
          padding,
          newMessageTextField,
          padding,
          numberOfSidesTextField];

    var editableFieldsSection = new Container(
      padding: EdgeInsets.all(20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("Better Letters"),
      ),
      body: ListView(children: <Widget>[
        editableFieldsSection,
        new GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: .1,
          crossAxisSpacing: .1,
          padding: EdgeInsets.all(15.0),
          shrinkWrap: true,
          childAspectRatio: 5.0,
          children: List.generate(this.neededLetters.length, (index) {
            var key = this.neededLetters.keys.elementAt(index);
            var value = this.neededLetters[key];
            return new Container(
              child: new Center(
                child: Text(
                  '$key - $value needed.',
                ),
              ),
              /*decoration: new BoxDecoration(color: Colors.blue),*/
            );
          }),
        )
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
