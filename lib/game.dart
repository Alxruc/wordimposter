import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  final List<String> players;

  GamePage({required this.players});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String impostor = '';
  Map<String, bool> isImpostor = {};
  int currentIndex = 0;

  void _chooseImpostor() {
    impostor = widget.players[Random().nextInt(widget.players.length)];
    isImpostor = {for (var e in widget.players) e: e == impostor};
  }

  Text _showImpostorStatus() {
    int index = currentIndex;
    String player = widget.players[index ~/ 2];
    print('index: $index, player: $player');
    if (index % 2 == 0) {
      // Show that you have to pass the phone to the next player
      return Text('Pass the phone to $player');
    }
    // Show if the player is the impostor or not
    bool isPlayerImpostor = isImpostor[player] ?? false;

    return Text(
        isPlayerImpostor ? 'You are the impostor' : 'You are not the impostor');
  }

  @override
  void initState() {
    super.initState();
    _chooseImpostor();
  }

  void _nextPlayer() {
    setState(() {
      currentIndex = (currentIndex + 1) % (widget.players.length * 2 + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Center(
        child: Column(
          children: [
            currentIndex < (widget.players.length * 2)
                ? Column(
                    children: [
                      _showImpostorStatus(),
                      ElevatedButton(
                        onPressed: _nextPlayer,
                        child: Text('Next player'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _nextPlayer,
                    child: Text('Start'),
                  ),
          ],
        ),
      ),
    );
  }
}
