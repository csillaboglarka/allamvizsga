import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allamvizsga/Screens/Mainscreens/Events/DetailScreens/ListWidget_DetailScreen.dart'; // Importálni kell a DetailListScreen-t

class TopWidget extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const TopWidget({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String eventDate = eventData['event_date'] ?? '';
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(eventDate);
    } catch (e) {
      parsedDate = null;
    }
    String formattedDate = parsedDate != null ? DateFormat('yyyy.MM.dd').format(parsedDate) : 'Nincs adat';

    final String eventName = eventData['event_name'] ?? 'Ismeretlen esemény';
    final String eventImage = eventData['event_image1'] ?? 'https://via.placeholder.com/150';
    final String eventType = eventData['event_type'] ?? 'General';
    final String eventId = eventData['event_id'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Latest Event",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailListScreen(idDoc: eventId),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(eventImage),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            eventName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 20,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                eventType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}