import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xo_bloc/classes/game_stats.dart';
import 'package:xo_bloc/core/bloc/board_event.dart';
import 'package:xo_bloc/core/bloc/board_state.dart';
import 'package:xo_bloc/core/constants/players.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BoardBloc() : super(BoardInitState()) {
    on<MakeMoveEvent>(_onMakeMove);
  }

  void _onMakeMove(MakeMoveEvent event, Emitter<BoardState> emit) async {
    // Check if the move is valid
    if (GameStats.mainBoard.handleTap(event.cellIndex)) {
      // Update the board in Firestore
      await _updateFirestoreBoard();

      // Check for a winner
      final winner = GameStats.mainBoard.checkWinner();
      if (winner != null) {
        await _updateFirestoreWinner(winner);
      }

      // Emit a state to update the UI
      emit(BoardUpdateState());
    }
  }

  Future<void> _updateFirestoreBoard() async {
    await _firestore
        .collection('games')
        .doc(GameStats.gameCode.toString())
        .update({
      'board': GameStats.mainBoard.board,
      'currentTurn': GameStats.currentPlayer == AppPlayers.playerX ? 0 : 1,
      'winner': getWinner()
    });
  }

  int getWinner() {
    return GameStats.gameWinner == AppPlayers.playerX
        ? 1
        : GameStats.gameWinner == AppPlayers.playerO
            ? 0
            : GameStats.gameWinner == null
                ? -1
                : 2;
  }

  Future<void> _updateFirestoreWinner(String winner) async {
    int winnerCode = winner == 'X' ? 1 : 0; // 1 for X, 0 for O
    await _firestore
        .collection('games')
        .doc(GameStats.gameCode.toString())
        .update({
      'winner': winnerCode,
    });
  }
}
