import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constant;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailListScreen extends StatefulWidget {
  final String idDoc;

  const DetailListScreen({Key? key, required this.idDoc}) : super(key: key);

  @override
  _DetailListScreenState createState() => _DetailListScreenState();
}

final LatLng marosvasarhelyCoords = LatLng(46.5421, 24.5569);

class _DetailListScreenState extends State<DetailListScreen> {
  late Future<Map<String, dynamic>> fetchDataFuture;
  late GoogleMapController mapController;

  final String darkMapStyle = '''
    [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8ec3b9"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a3646"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#64779e"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#334e87"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6f9ba5"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3C7680"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#304a7d"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c6675"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#255763"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#b0d5ce"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3a4762"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0e1626"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#4e6d70"
      }
    ]
  }
]
  ''';

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    print('idDoc: ${widget.idDoc}');
  }

  Future<Map<String, dynamic>> fetchData() async {
    final String idDoc = widget.idDoc;
    final String url = '${constant.cim}detail_culture.php?id=$idDoc';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList.first;
        return data;
      } else {
        throw Exception('No data available for the specified ID');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Térkép vezérlő inicializálása
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(darkMapStyle);  // Alkalmazzuk a sötét stílust
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final data = snapshot.data!;
          final eventImage = data['event_image1'] ?? ''; // Kép URL
          final eventDate = data['event_date'] ?? ''; // Dátum
          final eventCity = data['event_city'] ?? ''; // Város
          final eventName = data['event_name'] ?? ''; // Esemény neve

          return Column(
            children: [
              Container(
                height: 200, // A kép kívánt magassága
                width: double.infinity, // A kép szélessége teljes képernyőre
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(eventImage), // Kép URL betöltése
                    fit: BoxFit.cover, // A kép kitölti a rendelkezésre álló teret
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Első rész - Kép
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          eventCity, // Itt jelenik meg a város
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Fehér szöveg a kék háttéren
                          ),
                        ),
                      ),
                      // Második rész - Esemény információk
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey),
                          SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              eventDate, // A dátum, amit az API-tól kaptunk
                              style: TextStyle(color: Colors.black), // Fehér szöveg
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              eventCity, // A város adatot az event_city kulcsból tölti be
                              style: TextStyle(color: Colors.black), // Fehér szöveg
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Harmadik rész - Leírás
                      Text(
                        'About the Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'Join us for an unforgettable night of music and entertainment featuring top artistsdsd dssad asd asdasd asds sadas dsad sad asda sdsa asdsa sdddddddddddddddddddddddddddddddddddddddddddddddddddd.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: marosvasarhelyCoords,
                            zoom: 14.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("marosvasarhely"),
                              position: marosvasarhelyCoords,
                              infoWindow: InfoWindow(title: "Marosvásárhely"),
                            ),
                          },
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
