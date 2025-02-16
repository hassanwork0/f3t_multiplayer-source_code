// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:xo_bloc/classes/game_stats.dart';
import 'package:xo_bloc/core/bloc/board_bloc.dart';
import 'package:xo_bloc/core/bloc/board_event.dart';
import 'package:xo_bloc/core/bloc/board_state.dart';
import 'package:xo_bloc/core/constants/colors.dart';
import 'package:xo_bloc/core/constants/players.dart';
import 'package:xo_bloc/core/firebase/firebase_ins.dart';
import 'package:xo_bloc/core/routes/names.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BoardBloc board = context.read<BoardBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("game number #${GameStats.gameCode}"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseIns()
              .firestore
              .collection('games')
              .doc(GameStats.gameCode.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Game not found'));
            }

            loadGameData(snapshot);

            return Center(child: BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (GameStats.gameWinner != null)
                      Text("${GameStats.gameWinner} Won!"),
                    if (GameStats.gameWinner == null)
                      Text("Current Player is : ${GameStats.currentPlayer}"),
                    SizedBox(
                      width: 500,
                      height: 500,
                      child: gridBuilder(GameStats.miniGameIndex, board),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        GameStats().resetStats();
                        Navigator.pushReplacementNamed(
                            context, RoutesName.splash);
                      },
                      child: const Text('To HomeScreen'),
                    ),
                  ],
                );
              },
            ));
          }),
    );
  }

  Widget gridBuilder(int gameIndex, BoardBloc board) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      ),
      itemCount: 9,
      itemBuilder: (context, cellIndex) {
        return GestureDetector(
          onTap: () {
            if(GameStats.gameWinner == null){
            board.add(MakeMoveEvent(cellIndex));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                GameStats.mainBoard.board[cellIndex],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GameStats.mainBoard.board[cellIndex] == 'X'
                      ? AppColor.xColor
                      : AppColor.oColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void loadGameData(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    final gameData = snapshot.data!.data() as Map<String, dynamic>;
    final boardState = gameData['board'] as List<dynamic>;
    final currentTurn = gameData['currentTurn'] as int;
    final winner = gameData['winner'] as int;

    // Update local game state
    GameStats.mainBoard.board = List<String>.from(boardState);
    GameStats.currentPlayer =
        currentTurn == 0 ? AppPlayers.playerX : AppPlayers.playerO;
    GameStats.gameWinner = winner == -1
        ? null
        : winner == 0
            ? AppPlayers.playerO
            : winner == 1
                ? AppPlayers.playerX
                : AppPlayers.draw;
  }
}
