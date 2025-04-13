import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allamvizsga/Screens/Mainscreens/Events/DetailScreens/ListWidget_DetailScreen.dart'; // Importálni kell a ListDetailScreen-t

class ListCard extends StatefulWidget {
  final Map<String, dynamic> cultureData;
  final Function(String) onPressed;
  final List<String> favoriteIds;
  final Function(String, bool) onFavoriteToggle;

  const ListCard({
    Key? key,
    required this.cultureData,
    required this.onPressed,
    required this.favoriteIds,
    required this.onFavoriteToggle, required bool isFavorite,
  }) : super(key: key);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.favoriteIds.contains(widget.cultureData['event_id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final String id = widget.cultureData['event_id']?.toString() ?? '';
    final String eventDate = widget.cultureData['event_date'] ?? '';
    final String eventType = widget.cultureData['event_type'] ?? 'Nincs típus';

    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(eventDate);
    } catch (e) {
      parsedDate = null;
    }

    String formattedDate = parsedDate != null ? DateFormat('yyyy.MM.dd').format(parsedDate) : 'Nincs adat';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailListScreen(idDoc: id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.cultureData['event_image1'] ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cultureData['event_name'] ?? 'Ismeretlen előadás',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        eventType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              widget.onFavoriteToggle(id, isFavorite);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}