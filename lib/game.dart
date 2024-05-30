import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'chooser.dart';

class GamePage extends StatefulWidget {
  final List<String> players;
  final String dropdownValue;

  GamePage({required this.players, required this.dropdownValue});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String impostor = '';
  Map<String, bool> isImpostor = {};
  List<String> wordList = [];
  String secretWord = '';
  bool revealed = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    getLines(widget.dropdownValue).then((lines) {
      setState(() {
        wordList = lines;
        _chooseImpostor();
      });
    });
  }

  void _chooseImpostor() {
    impostor = widget.players[Random().nextInt(widget.players.length)];
    isImpostor = {for (var e in widget.players) e: e == impostor};
    if (wordList.isNotEmpty) {
      int randomIndex = Random().nextInt(wordList.length);
      secretWord = wordList.removeAt(randomIndex);
    }
  }

  Text _passingAround() {
    // Everyone is shown the word except the impostor
    if (index % 2 == 0) {
      return Text(
          "Pass the device to ${widget.players[(index ~/ 2) % widget.players.length]}");
    }

    if (impostor == widget.players[(index ~/ 2) % widget.players.length]) {
      return Text("You are the impostor!");
    } else {
      return Text("The word is: $secretWord");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Column(
        children: [
          index < widget.players.length * 2
              ? Column(children: [
                  _passingAround(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        index++;
                      });
                    },
                    child:
                        index % 2 == 0 ? Text('Reveal word') : Text('Got it!'),
                  )
                ])
              : Column(children: [
                  revealed
                      ? Column(children: [
                          Text('The impostor is: $impostor'),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('End game'),
                          ),
                        ])
                      : Column(children: [
                          Text('The game has started!'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                revealed = true;
                              });
                            },
                            child: Text('Reveal the impostor'),
                          )
                        ]),
                ]),
        ],
      ),
    );
  }
}
