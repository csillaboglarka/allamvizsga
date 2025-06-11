import 'package:allamvizsga/Screens/Mainscreens/Events/Widgets/ListWidget.dart';
import 'package:allamvizsga/Screens/Mainscreens/Events/Widgets/TopWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constants;
import 'DetailScreens/ListWidget_DetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Events extends StatefulWidget {
  final String userId;
  const Events({Key? key, required this.userId}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<dynamic>? cultures;
  List<String> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    fetchCultureData();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      favoriteIds = await getFavoriteEvents(widget.userId);
      setState(() {});
    } catch (e) {
      print("Failed to load favorites: $e");
    }
  }

  Future<void> fetchCultureData() async {
    final response = await http.get(Uri.parse('${constants.cim}culture.php'));
    if (response.statusCode == 200) {
      setState(() {
        cultures = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load events data');
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

  Future<List<String>> getFavoriteEvents(String userId) async {
    final response = await http.get(Uri.parse('${constants.cim}get_favorites.php?user_id=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<String> favoriteEventIds = data.map((event) => event['event_id'].toString()).toList();
      return favoriteEventIds;
    } else {
      throw Exception('ERROR getting favorites');
    }
  }

  Future<void> toggleFavoriteOnServer(String userId, String eventId, bool isFavorite) async {
    final response = await http.post(
      Uri.parse('${constants.cim}favorites.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'event_id': eventId,
        'is_favorite': isFavorite,
      }),
    );
    print('Raw response: ${response.body}');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      print(result['message']);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  toggleFavorite(String id, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteIds.add(id);
      } else {
        favoriteIds.remove(id);
      }
    });

    toggleFavoriteOnServer(widget.userId, id, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cultures != null && cultures!.isNotEmpty)
              TopWidget(eventData: cultures!.first),
            const SizedBox(height: 20),
            const Text(
              'Events nearby',
              style: TextStyle(
                fontFamily: 'Graduate',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: cultures?.map<Widget>((cultureData) {
                final isFavorite = favoriteIds.contains(cultureData['event_id'].toString());
                return ListCard(
                  cultureData: cultureData,
                  onPressed: navigateToDetailListScreen,
                  favoriteIds: favoriteIds,
                  onFavoriteToggle: toggleFavorite,
                  isFavorite: isFavorite,
                );
              }).toList() ?? [],
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
