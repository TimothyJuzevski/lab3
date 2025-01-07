import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/custom_card.dart';
import 'favorites_screen.dart';

class JokesScreen extends StatefulWidget {
  final String type;
  final List<Map<String, dynamic>> favoriteJokes;

  JokesScreen({required this.type, required this.favoriteJokes});

  @override
  _JokesScreenState createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  late Future<List<Map<String, dynamic>>> jokes;

  @override
  void initState() {
    super.initState();
    jokes = ApiServices.fetchJokesByType(widget.type);
  }

  void addToFavorites(Map<String, dynamic> joke) {
    setState(() {
      widget.favoriteJokes.add(joke);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteJokes: widget.favoriteJokes,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load jokes."));
          } else {
            final jokesList = snapshot.data!;
            return ListView.builder(
              itemCount: jokesList.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  title: jokesList[index]['setup'],
                  subtitle: jokesList[index]['punchline'],
                  onTap: () {}, // No action on tap for now
                  trailing: IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () => addToFavorites(jokesList[index]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
