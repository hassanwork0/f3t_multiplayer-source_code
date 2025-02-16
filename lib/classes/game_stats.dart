import 'package:xo_bloc/classes/mini_game.dart';
import 'package:xo_bloc/core/constants/players.dart';

class GameStats {
  static MiniGame mainBoard = MiniGame();
  static String currentPlayer = AppPlayers.playerX;
  static String? gameWinner;
  static int miniGameIndex = 4;
  static int gameCode = -1;
  static int currentAvailID = -1;
  
  void resetStats() {
    mainBoard = MiniGame();
    currentPlayer = AppPlayers.playerX;
    gameWinner = null;
    miniGameIndex = 4;
    gameCode = -1;
  }
}
