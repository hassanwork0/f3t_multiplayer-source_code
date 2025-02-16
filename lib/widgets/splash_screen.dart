import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xo_bloc/classes/game_stats.dart';
import 'package:xo_bloc/core/routes/names.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: getHighestGameID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading..."),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if something went wrong
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data == '-1') {
            // Show a message if no games are found or an error occurred
            return Center(
              child: Text("No games found or error occurred."),
            );
          } else {
            // Update the currentAvailID and navigate to the home screen
            GameStats.currentAvailID = int.parse(snapshot.data!)+1;

            // Use a post-frame callback to navigate after the build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, RoutesName.home);
            });

            // Return a placeholder widget while navigating
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<String> getHighestGameID() async {
    try {
      // Query Firestore to get the document with the highest ID
      final querySnapshot = await FirebaseFirestore.instance
          .collection('games')
          .orderBy('gameCode', descending: true) // Order by document ID
          .limit(1) // Limit to 1 document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the ID from the first document
        final highestID = int.parse(querySnapshot.docs.first.id);
        return '$highestID';
      } else {
        // If no documents exist, return 0 or any default value
        return '0';
      }
    } catch (e) {
      return '-1'; // Return -1 to indicate an error
    }
  }
}