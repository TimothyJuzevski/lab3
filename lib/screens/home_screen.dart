import 'package:flutter/material.dart';
import 'jokes_screen.dart';
import '../services/api_services.dart';
import '../widgets/custom_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;
  List<Map<String, dynamic>> favoriteJokes = []; // List to hold favorite jokes

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiServices.fetchJokeTypes();
    requestNotificationPermissions();
    subscribeToTopic();
    scheduleDailyNotification();
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          NotificationService.showNotification(
            title: message.notification!.title ?? "Notification",
            body: message.notification!.body ?? "No content",
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void subscribeToTopic() {
    FirebaseMessaging.instance.subscribeToTopic('dailyJokes');
  }

  void scheduleDailyNotification() {
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 9, 0); // Schedule for 9 AM

    // If the scheduled time is in the past for today, schedule for the next day
    if (scheduledTime.isBefore(now)) {
      final nextDayTime = scheduledTime.add(Duration(days: 1));
      NotificationService.scheduleNotification(
        title: 'Daily Joke',
        body: 'Here is your daily dose of laughter!',
        scheduledTime: nextDayTime,
      );
    } else {
      NotificationService.scheduleNotification(
        title: 'Daily Joke',
        body: 'Here is your daily dose of laughter!',
        scheduledTime: scheduledTime,
      );
    }
  }

  void showRandomJoke(BuildContext context) async {
    final randomJoke = await ApiServices.fetchRandomJoke();
    if (randomJoke != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Random Joke"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(randomJoke['setup']),
              SizedBox(height: 10),
              Text(
                randomJoke['punchline'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch a random joke.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('201546'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_emotions), // Use a suitable icon
            onPressed: () => showRandomJoke(context),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load joke types."));
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
                        builder: (context) => JokesScreen(
                          type: types[index],
                          favoriteJokes: favoriteJokes, // Pass the list here
                        ),
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