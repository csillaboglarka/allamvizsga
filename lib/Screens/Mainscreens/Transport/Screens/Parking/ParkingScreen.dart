import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:allamvizsga/Screens/Mainscreens/Transport/Screens/Parking/Screens/DetailParkingScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:allamvizsga/network/constants.dart' as constant;

class ParkingScreen extends StatefulWidget {
  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isLoading = true;
  Map<String, dynamic>? _selectedCategory;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _fetchParkingData();
  }

  Future<void> _fetchParkingData() async {
    try {
      final response = await http.get(Uri.parse('${constant.cim}parking.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.cast<Map<String, dynamic>>();
          _filteredCategories = _categories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load parking data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _showDropdown = value.isNotEmpty;
                        _filteredCategories = _categories
                            .where((category) => category['strName']
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Street name',
                      hintStyle: const TextStyle(fontSize: 18),
                      prefixIcon: const Icon(Icons.location_on,
                          color: Colors.grey, size: 30),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            _showDropdown = !_showDropdown;
                            _filteredCategories = _categories;
                          });
                        },
                      ),
                    ),
                  ),
                  if (_showDropdown)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];
                          return ListTile(
                            title: Text(category['strName']),
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                                _searchController.text =
                                category['strName'];
                                _showDropdown = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedCategory != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailParkingScreen(
                                idz: _selectedCategory!['idz'],
                                strName: _selectedCategory!['strName'],
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                        const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Find',
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
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 260,
                child: PhotoView(
                  imageProvider:
                  const AssetImage('assets/parking_map.jpg'),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration:
                  const BoxDecoration(color: Colors.black),
                  heroAttributes:
                  const PhotoViewHeroAttributes(tag: 'uniqueTag'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
