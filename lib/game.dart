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

  TextStyle gameStyle() {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: MediaQuery.of(context).size.width * 0.08);
  }

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
        "Pass the device to ${widget.players[(index ~/ 2) % widget.players.length]}",
        textAlign: TextAlign.center,
        style: gameStyle(),
      );
    }

    if (impostor == widget.players[(index ~/ 2) % widget.players.length]) {
      return Text(
        "You are the impostor!",
        textAlign: TextAlign.center,
        style: gameStyle(),
      );
    } else {
      return Text(
        "The word is: $secretWord",
        textAlign: TextAlign.center,
        style: gameStyle(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Impostor Game'),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: SingleChildScrollView(
            child: index < widget.players.length * 2
                ? Flex(
                    direction: Axis.vertical,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.2,
                        child: _passingAround(),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.4,
                        child: Visibility(
                          visible: index % 2 == 0,
                          child: Text("📱➡️",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.11)),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              index++;
                            });
                          },
                          child: index % 2 == 0
                              ? const Text('REVEAL WORD!',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : index == widget.players.length * 2 - 1
                                  ? const Text('START THE GAME!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                  : const Text('NEXT PLAYER!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                : Flex(
                    direction: Axis.vertical,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.3,
                        child: revealed
                            ? Text('The impostor is: $impostor',
                                style: gameStyle())
                            : Text('The game has started!', style: gameStyle()),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (revealed) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                revealed = true;
                              });
                            }
                          },
                          child: revealed
                              ? const Text('END GAME!',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : const Text(
                                  'REVEAL THE IMPOSTOR!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}
