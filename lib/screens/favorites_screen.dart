import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteJokes;

  FavoritesScreen({required this.favoriteJokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jokes'),
        backgroundColor: Colors.purple,
      ),
      body: favoriteJokes.isEmpty
          ? Center(
        child: Text(
          'No favorite jokes yet!',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = favoriteJokes[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(joke['setup']),
              subtitle: Text(joke['punchline']),
            ),
          );
        },
      ),
    );
  }
}
