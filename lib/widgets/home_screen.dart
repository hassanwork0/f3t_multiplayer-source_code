import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xo_bloc/classes/game_stats.dart';
import 'package:xo_bloc/core/constants/colors.dart';
import 'package:xo_bloc/core/constants/players.dart';
import 'package:xo_bloc/core/routes/names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppColor.splash,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Welcome!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            welcomeText(),
            style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: AppColor.white),
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              tName(context, controller),
              startBtn(context, controller),
              currentAvailID()
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget tName(BuildContext context, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Enter your Game code...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        cursorColor: Colors.blue,
        controller: controller,
        onSubmitted: (value) => start(context, controller),
      ),
    );
  }

  Widget startBtn(BuildContext context, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.xColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap:(){
            start(context ,controller);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Text("Start",
                style: TextStyle(fontSize: 35, color: AppColor.white)),
          ),
        ));
  }

  String welcomeText() {
    return "Welcome to \n XO Multiplayer";
  }

  Text currentAvailID() {
    return Text(
      "Current Avail ID is : ${GameStats.currentAvailID}",
      style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: AppColor.white),
      textAlign: TextAlign.center,
    );
  }
  
  start (BuildContext context, TextEditingController controller) async {
            try {
              int gameCode = int.parse(controller.text);
              GameStats.gameCode = gameCode;

              final docSnapshot = await FirebaseFirestore.instance
                  .collection('games')
                  .doc(gameCode.toString())
                  .get();

              if (docSnapshot.exists) {
                final gameData = docSnapshot
                    .data(); // Use data() method instead of casting directly

                if (gameData != null) {
                  // Safely cast and validate boardState
                  final boardState = gameData['board'];
                  if (boardState is List<dynamic>) {
                    GameStats.mainBoard.board =
                        List<String>.from(boardState.map((e) => e.toString()));
                  } else {
                    controller.text = ("Invalid board state in Firestore");
                    return;
                  }

                  // Safely cast and validate currentTurn
                  final currentTurn = gameData['currentTurn'];
                  if (currentTurn is int) {
                    GameStats.currentPlayer = currentTurn == 0
                        ? AppPlayers.playerX
                        : AppPlayers.playerO;
                  } else {
                    controller.text = ("Invalid currentTurn in Firestore");
                    return;
                  }

                  final winner = gameData['winner'];
                  if (winner != -1) {
                    GameStats.gameWinner = winner == 1
                        ? AppPlayers.playerX
                        : winner == 2
                            ? AppPlayers.draw
                            : AppPlayers.playerO;
                  }

                  // Proceed to the game screen
                  Navigator.pushReplacementNamed(context, RoutesName.game);
                } else {
                  controller.text = ("Game document has no data");
                  controller.text = "Game data is corrupted";
                }
              } else {
                await FirebaseFirestore.instance
                    .collection('games')
                    .doc(gameCode.toString())
                    .set({
                  'gameCode': gameCode,
                  'board': List.filled(9, ''),
                  'winner': -1,
                  'currentTurn': 0,
                });
              }

              Navigator.pushReplacementNamed(context, RoutesName.game);
            } catch (e) {
              controller.text = e.toString();
            }
          
     
    }
}
