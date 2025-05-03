import 'package:flutter/material.dart';

class DetailParkingScreen extends StatelessWidget {
  final String idz;
  final String strName;

  const DetailParkingScreen({Key? key, required this.idz, required this.strName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, String>>> zonePrices = {
      '0': [
        {"duration": "30 Minutes", "price": "2,50 Lei"},
        {"duration": "1 hour", "price": "3,50 Lei"},
        {"duration": "1 day", "price": "11,50 Lei"},
      ],
      '1': [
        {"duration": "30 Minutes", "price": "2,00 Lei"},
        {"duration": "1 hour", "price": "3,00 Lei"},
        {"duration": "1 day", "price": "10,00 Lei"},
      ],
      '2': [
        {"duration": "30 Minutes", "price": "1,50 Lei"},
        {"duration": "1 hour", "price": "2,50 Lei"},
        {"duration": "1 day", "price": "9,00 Lei"},
      ],
    };

    final prices = zonePrices[idz] ?? zonePrices['0']!;

    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: ClipRRect(
            child: Image.asset(
              'assets/parking_h.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Zone Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.access_time, size: 18, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              "Program Luni-Vineri 8-18",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Zona',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          idz,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TPark Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/tpark.png", width: 30),
                      const SizedBox(width: 10),
                      const Text("TPARK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...prices.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item["duration"]!, style: const TextStyle(fontSize: 16)),
                        Text(item["price"]!, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SMS Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, size: 30, color: Colors.blue),
                      const SizedBox(width: 10),
                      const Text("SMS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Text("NR.7420", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...prices.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item["duration"]!, style: const TextStyle(fontSize: 16)),
                            Text(item["price"]!, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("Text: 553 Reg.Nr   Ex. 553 MS00AAA", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
