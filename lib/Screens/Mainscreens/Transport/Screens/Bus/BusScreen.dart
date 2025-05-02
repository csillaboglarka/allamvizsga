import 'dart:convert';
import 'package:allamvizsga/Screens/Mainscreens/Transport/Screens/Bus/widget/buscard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/network/constants.dart' as constant;

class DropDownItem {
  final String value;
  final String label;
  String idInduloMegallo;
  String megallosorrend;
  String lehet_indulo;

  DropDownItem({
    required this.value,
    required this.label,
    required this.idInduloMegallo,
    required this.megallosorrend,
    required this.lehet_indulo,
  });
}

class Bus {
  final DropDownItem source;
  final DropDownItem destination;
  String vonal;
  final String erkezesiido;
  final String megallasiido;
  final String travelTime;

  Bus({
    required this.source,
    required this.destination,
    required this.vonal,
    required this.erkezesiido,
    required this.megallasiido,
    required this.travelTime,
  });
}

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  _BusScreenState createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<DropDownItem> cities = [];
  List<DropDownItem> destinationCities = [];
  DropDownItem? sourceCity;
  DropDownItem? destinationCity;
  bool isSearchPressed = false;
  final List<Bus> buses = [];

  @override
  void initState() {
    super.initState();
    fetchMegallo();
  }

  Future<void> fetchMegallo() async {
    final response = await http.get(Uri.parse('${constant.cim}megallok.php'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        cities = responseData
            .where((item) => item['lehet_indulo'] == '1')
            .map((item) => DropDownItem(
            value: item['id_megallo'],
            label: item['megallo_neve'],
            idInduloMegallo: item['id_indulo_megallo'],
            lehet_indulo: item['lehet_indulo'],
            megallosorrend: item['megallo_sorrend']))
            .toList();
      });
    } else {
      throw Exception('A városok betöltése sikertelen');
    }
  }

  void fetchDestinationCities() {
    setState(() {
      destinationCities = cities
          .where((item) =>
      item.idInduloMegallo == sourceCity?.idInduloMegallo &&
          (int.tryParse(item.megallosorrend) ?? 0) >
              (int.tryParse(sourceCity?.megallosorrend ?? '0') ?? 0) &&
          item.lehet_indulo == '1')
          .toList();
    });
  }


  String calculateLeavesIn(String departureTimeStr) {
    try {
      final now = DateTime.now();
      final parts = departureTimeStr.split(':');
      if (parts.length != 2) return 'N/A';
      final depTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      final difference = depTime.difference(now);
      final minutes = difference.inMinutes;
      return minutes > 0 ? '$minutes perc' : 'Indult';
    } catch (e) {
      return 'N/A';
    }
  }


  Future<String> fetchVonalszam(String sourceCityId, String destinationCityId) async {
    final response = await http.get(Uri.parse('${constant
        .cim}vonalszam.php?sourceCity=$sourceCityId&destinationCity=$destinationCityId'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch vonalszam');
    }
  }

  Future<Map<String, String>> fetchUtazasIdo(String sourceCityId, String destinationCityId) async {
    final response = await http.get(
      Uri.parse('${constant.cim}utazasido.php?sourceCityId=$sourceCityId&destinationCityId=$destinationCityId'),
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        List<String> departureTimes = List<String>.from(responseData['departureTimes']);

        String erkezesiido = departureTimes.isNotEmpty ? departureTimes[0] : 'Nincs idő';
        String megallasiido = departureTimes.length > 1 ? departureTimes[1] : 'Nincs idő';
        String differenceInMinutes = responseData['differenceInMinutes'].toString();

        return {
          'erkezesiido': erkezesiido,
          'megallasiido': megallasiido,
          'differenceInMinutes': differenceInMinutes,
        };
      } catch (e) {
        throw Exception('Failed to parse travel times: $e');
      }
    } else {
      throw Exception('Failed to fetch travel times');
    }
  }

  void searchBuses() async {
    setState(() {
      isSearchPressed = true;
      buses.clear();
    });

    try {
      String vonal = await fetchVonalszam(sourceCity!.idInduloMegallo, destinationCity!.idInduloMegallo);

      if (vonal.isEmpty || vonal == '0') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nincs buszjárat')),
        );
      } else {
        Map<String, String> utazasAdatok = await fetchUtazasIdo(sourceCity!.value, destinationCity!.value);

        setState(() {
          buses.add(
            Bus(
              source: sourceCity!,
              destination: destinationCity!,
              vonal: vonal,
              erkezesiido: utazasAdatok['erkezesiido']!,
              megallasiido: utazasAdatok['megallasiido']!,
              travelTime: utazasAdatok['differenceInMinutes']!,
            ),
          );
        });
      }
    } catch (e) {
      print('Hiba történt az utazási idők lekérdezése közben: $e');
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
              'assets/bush.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height:20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<DropDownItem>(
                    value: sourceCity,
                    decoration: InputDecoration(
                      hintText: 'From Where',
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city.label),
                      );
                    }).toList(),
                    onChanged: (DropDownItem? newValue) {
                      setState(() {
                        sourceCity = newValue;
                        destinationCity = null;
                        fetchDestinationCities();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<DropDownItem>(
                    value: destinationCity,
                    decoration: InputDecoration(
                      hintText: 'Destination',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: destinationCities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city.label),
                      );
                    }).toList(),
                    onChanged: (DropDownItem? newValue) {
                      setState(() {
                        destinationCity = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (sourceCity != null && destinationCity != null) {
                          searchBuses();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kérlek válassz megállókat!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  return BusCard(
                    source: buses[index].source.label,
                    destination: buses[index].destination.label,
                    travelTime: buses[index].travelTime,
                    line: buses[index].vonal,
                    leavesIn: calculateLeavesIn(buses[index].erkezesiido),
                    departureTime: buses[index].erkezesiido,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
