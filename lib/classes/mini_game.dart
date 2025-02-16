

import 'package:xo_bloc/classes/game_stats.dart';
import 'package:xo_bloc/core/constants/players.dart';

class MiniGame {
  List<String> board = List.filled(9, '');
  String? miniGameWinner;

  String? checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != AppPlayers.emptyCell &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
            GameStats.gameWinner = "${board[combination[0]]} Wins";
        return board[combination[0]];
      }
    }

    if (board.every((game) => game.isNotEmpty)) {
      GameStats.gameWinner = AppPlayers.draw;
    }

    return null;
  }

    bool handleTap(int cellIndex) {
    if (GameStats.mainBoard.miniGameWinner == null &&
        GameStats.mainBoard.board[cellIndex] ==
            AppPlayers.emptyCell) {
        GameStats.mainBoard.board[cellIndex] =
            GameStats.currentPlayer;
        GameStats.mainBoard.miniGameWinner =
            GameStats.mainBoard.checkWinner();
        if (GameStats.mainBoard.miniGameWinner != null) {
        }
        GameStats.currentPlayer = GameStats.currentPlayer == AppPlayers.playerX
            ? AppPlayers.playerO
            : AppPlayers.playerX; 

            return true;    
    }
    return false;
  }
}
