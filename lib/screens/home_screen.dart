import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'jokes_screen.dart';
import 'random_joke_screen.dart';
import '../widgets/custom_card.dart';
import '../widgets/centered_message.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiServices.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("201546"),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.sentiment_very_satisfied),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenteredMessage(
              message: "Loading joke types...",
              icon: Icons.hourglass_empty,
            );
          } else if (snapshot.hasError) {
            return CenteredMessage(
              message: "Failed to load joke types. Please try again.",
              icon: Icons.error_outline,
            );
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  title: types[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokesScreen(type: types[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
