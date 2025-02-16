library;

import 'package:flutter/material.dart';
import 'package:xo_bloc/widgets/game_screen.dart';
import 'package:xo_bloc/widgets/home_screen.dart';
import 'package:xo_bloc/widgets/splash_screen.dart';
import 'routes.dart';

class AppRoute {
  static Route<dynamic> generate(RouteSettings? settings) {
    switch (settings?.name) {
        case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
        case RoutesName.home:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case RoutesName.game:
        return MaterialPageRoute(
          builder: (context) => GameScreen(),
        );


      default:
      return MaterialPageRoute(
          builder: (context) => Test(),
        );
    }
  }
}


class Test extends StatelessWidget{
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("error"),),
    );
  }

}