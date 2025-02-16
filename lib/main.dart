import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_bloc/core/bloc/board_bloc.dart';
import 'package:xo_bloc/core/routes/names.dart';
import 'package:xo_bloc/core/routes/pages.dart';
import 'package:xo_bloc/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Multiplayer Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRoute.generate,
        initialRoute: RoutesName.splash,
      ),
    );
  }
}
