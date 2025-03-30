import 'package:allamvizsga/Screens/Mainscreens/Events/Widgets/ListWidget.dart';
import 'package:allamvizsga/Screens/Mainscreens/Events/Widgets/TopWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constants;
import 'DetailScreens/ListWidget_DetailScreen.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

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
  }

  Future<void> fetchCultureData() async {
    final response = await http.get(Uri.parse('${constants.cim}culture.php'));
    if (response.statusCode == 200) {
      setState(() {
        cultures = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load culture data');
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
        favoriteIds.add(id);
      } else {
        favoriteIds.remove(id);
      }
    });
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
                return ListCard(
                  cultureData: cultureData,
                  onPressed: navigateToDetailListScreen,
                  favoriteIds: favoriteIds,
                  onFavoriteToggle: toggleFavorite,
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
