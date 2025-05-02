import 'package:allamvizsga/Screens/Mainscreens/Transport/Screens/Bus/BusScreen.dart';
import 'package:allamvizsga/Screens/Mainscreens/Transport/Screens/Parking/ParkingScreen.dart';
import 'package:allamvizsga/Screens/Mainscreens/Transport/Screens/Taxi/TaxiScreen.dart';
import 'package:flutter/material.dart';
import 'package:allamvizsga/Screens/Mainscreens/Transport/Widgets/mainWidget.dart';

class TransportScreen extends StatelessWidget {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRRect(
            child: Image.asset(
              'assets/transport_header.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(
          children: [
            WidgetCard(
              title: 'Bus',
              icon: Icons.directions_bus,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusScreen()),
            );
          },
        ),

            const SizedBox(height: 16),
            WidgetCard(
              title: 'Taxi',
              icon: Icons.local_taxi,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaxiScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            WidgetCard(
              title: 'Parking',
              icon: Icons.local_taxi,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParkingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
