import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:allamvizsga/network/constants.dart' as constant;

class TaxiScreen extends StatefulWidget {
  const TaxiScreen({super.key});

  @override
  State<TaxiScreen> createState() => _TaxiScreenState();
}

class _TaxiScreenState extends State<TaxiScreen> {
  List<Map<String, String>> taxis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaxis();
  }

  Future<void> fetchTaxis() async {
    const String url = '${constant.cim}get_taxi.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          taxis = data
              .map((json) => {
            'name': json['name'] as String,
            'phone': json['phone'] as String,
          })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Sikertelen kérés: ${response.statusCode}');
      }
    } catch (e) {
      print('Hiba a taxi adatok lekérésekor: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _callTaxi(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nem lehet megnyitni a tárcsázót.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: ClipRRect(
            child: Image.asset(
              'assets/taxi.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: taxis.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final taxi = taxis[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.local_taxi, size: 40, color: Colors.blue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taxi['name']!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          taxi['phone']!,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, size: 30, color: Colors.blue),
                    onPressed: () => _callTaxi(taxi['phone']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




