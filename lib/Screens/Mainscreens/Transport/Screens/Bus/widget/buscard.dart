import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final String source;
  final String destination;
  final String travelTime;
  final String line;
  final String leavesIn;
  final String departureTime;

  const BusCard({
    super.key,
    required this.source,
    required this.destination,
    required this.travelTime,
    required this.line,
    required this.leavesIn,
    required this.departureTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF004EC2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Left: "15 min" box
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
              '$travelTime',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF004EC2),
                    ),
                  ),
                  const Text(
                    "min",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF004EC2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and destination
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        source,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                      Text(
                        destination,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_bus, size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              line,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Clock and time
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        departureTime,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
