import 'package:flutter/material.dart';
import 'game.dart';
import 'chooser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Word Imposter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> players = [];
  final TextEditingController _namesController = TextEditingController();
  String dropdownValue = 'Actors';
  List<String> celebrityFiles = getCelebrityFiles();

  void _addPlayer() {
    setState(() {
      players.add(_namesController.text);
      _namesController.clear();
    });
  }

  void _clearPlayers() {
    setState(() {
      players.clear();
    });
  }

  void _startGame() {
    if (players.length < 3) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Not enough players"),
            content:
                const Text("You need at least 3 players to start the game."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Start the game
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GamePage(players: players, dropdownValue: dropdownValue),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items:
                  celebrityFiles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(
              'Enter all of the player names:',
            ),
            Text(
              '$players',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _namesController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter a name",
              ),
            ),
            ElevatedButton(
              onPressed: _clearPlayers,
              child: const Text('Clear Players'),
            ),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
