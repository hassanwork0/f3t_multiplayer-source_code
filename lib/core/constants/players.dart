
import 'package:xo_bloc/classes/game_stats.dart';

class AppPlayers{
  static const String playerX = "X";
  static const String playerO = "O";
  

  static String get winner {
    return "Player ${GameStats.gameWinner} Won!";
  } 


  static const String draw = "It's a Draw!";

  static const String emptyCell = '';
}