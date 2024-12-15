import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/custom_card.dart';
import '../widgets/centered_message.dart';

class JokesScreen extends StatelessWidget {
  final String type;

  JokesScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: ApiServices.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CenteredMessage(
              message: "Loading jokes of type $type...",
              icon: Icons.hourglass_empty,
            );
          } else if (snapshot.hasError) {
            return CenteredMessage(
              message: "Failed to load jokes. Please try again.",
              icon: Icons.error_outline,
            );
          } else {
            final jokes = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  title: jokes[index]['setup'],
                  subtitle: jokes[index]['punchline'],
                  onTap: () {}
                );
              },
            );
          }
        },
      ),
    );
  }
}
