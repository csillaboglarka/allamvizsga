import 'package:allamvizsga/Screens/Mainscreens/Events/DetailScreens/ListWidget_DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constants;
import 'package:allamvizsga/Screens/Mainscreens/Events/Widgets/ListWidget.dart';

class Favorites extends StatefulWidget {
  final String userId;

  const Favorites({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<dynamic>? favoriteEvents;

  @override
  void initState() {
    super.initState();
    fetchFavoriteEvents();
  }

  Future<void> fetchFavoriteEvents() async {
    final response = await http.get(
      Uri.parse('${constants.cim}get_favoritesOnProfile.php?user_id=${widget.userId}'),
    );
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        favoriteEvents = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load favorite events');
    }
  }

  Future<void> removeFavoriteEvent(String eventId) async {
    final response = await http.post(
      Uri.parse('${constants.cim}remove_favorite.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': widget.userId,
        'event_id': eventId,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print(result['message']);
      fetchFavoriteEvents(); // Frissítjük a kedvencek listáját
    } else {
      print('Hiba történt a kedvenc eltávolításakor');
    }
  }

  void navigateToDetailListScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailListScreen(idDoc: id),
      ),
    );
  }

  void toggleFavorite(String id, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteEvents!.removeWhere((event) => event['event_id'].toString() == id);
      } else {
        fetchFavoriteEvents();
      }
    });
    removeFavoriteEvent(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        title: const Text('My Favorite Events'),
        backgroundColor: Colors.blue,
      ),
      body: favoriteEvents == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favoriteEvents!.length,
        itemBuilder: (context, index) {
          final event = favoriteEvents![index];
          final eventId = event['event_id'].toString(); // Int -> String
          final isFavorite = true;

          return ListCard(
            cultureData: event,
            onPressed: navigateToDetailListScreen,
            favoriteIds: [eventId],
            onFavoriteToggle: toggleFavorite,
            isFavorite: isFavorite,
          );
        },
      ),
    );
  }
}
