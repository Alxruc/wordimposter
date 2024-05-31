import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          textTheme: GoogleFonts.quicksandTextTheme(
            Theme.of(context).textTheme,
          )),
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
    print("called _addPlayer");
    if (_namesController.text.isEmpty) {
      return;
    }
    if (players.contains(_namesController.text)) {
      SnackBar snackBar = SnackBar(
        content: Text("Player already exists"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(), // Empty container for spacing
            ),
            Text(
              'Word\nImposter',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.1,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              )),
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black,
                    Colors.transparent
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(), // Empty container for spacing
            ),
            const Text(
              'Select a word category:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
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
            Expanded(
              flex: 14,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items in a row
                      childAspectRatio: 2.5,
                    ),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 233, 220, 220), // Light grey color
                          borderRadius:
                              BorderRadius.circular(10.0), // Rounded edges
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(players[index]),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close), // "X" button
                                onPressed: () {
                                  setState(() {
                                    players.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _namesController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Enter a name",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add), // Plus button
                    onPressed: () {
                      _addPlayer();
                    },
                  ),
                ),
                maxLength: 35,
              ),
            ),
            Visibility(
              visible: players.isNotEmpty,
              child: ElevatedButton(
                onPressed: _clearPlayers,
                child: const Text('Clear Players',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(), // Empty container for spacing
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: Text('START GAME!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.06)),
                )),
            Expanded(
              flex: 4,
              child: Container(), // Empty container for spacing
            ),
          ],
        ),
      ),
    );
  }
}
