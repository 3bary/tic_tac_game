import 'package:flutter/material.dart';
import 'package:tic_tac/logic/game_logic.dart';
import 'package:tic_tac/ui/color.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String activePlayer = "X";
  int turn = 0;
  bool isSwitched = false;
  bool gameOver = false;
  String result = '';
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          SwitchListTile.adaptive(
            activeColor: MainColor.accentColor,
            inactiveTrackColor: MainColor.secondaryColor,
            title: Text(
              'Turn on/off two player'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            value: isSwitched,
            onChanged: (bool newValue) {
              setState(() {
                isSwitched = newValue;
              });
            },
          ),
          Text(
            "it's $activePlayer turn".toUpperCase(),
            style: const TextStyle(fontSize: 54, color: Colors.white),
          ),
          Expanded(
              child: GridView.count(
            padding: const EdgeInsets.all(14),
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
            children: List.generate(
                9,
                (index) => GestureDetector(
                    onTap: gameOver ? null : () => _onTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                          color: MainColor.accentColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          Player.playerX.contains(index)
                              ? 'X'
                              : Player.playerO.contains(index)
                                  ? 'O'
                                  : '',
                          style: TextStyle(
                              color: MainColor.secondaryColor, fontSize: 60),
                        ),
                      ),
                    ),
                ),
            ),
          ),),
          Text(
            result,
            style: const TextStyle(fontSize: 42, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  Player.playerX = [];
                  Player.playerO = [];
                  activePlayer = "X";
                  gameOver = false;
                  turn = 0;
                  result = '';
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text(
                "Repeat The Game",
                style: TextStyle(fontSize: 24),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(MainColor.accentColor)),
            ),
          )
        ],
      )),
    );
  }

  _onTap(int index) async {
    if ((!Player.playerX.contains(index) || Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) || Player.playerO.isEmpty)) {
      game.playGame(index: index, activePlayer: activePlayer);
      updateState();
    }
    if ((!isSwitched && !gameOver && turn != 9)) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  updateState() {
    setState(() {
      turn++;
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      String winnerPlayer = game.checkWinner();
      if(winnerPlayer != ''){
        gameOver = true;
        result = 'the Winner is $winnerPlayer';
      }
      else if(turn == 9){
        result = 'DRAW';
      }
    });
  }
}
