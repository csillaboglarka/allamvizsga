import 'package:allamvizsga/Screens/Mainscreens/Places/Screens/CategoryListScreen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class ParkingScreen extends StatefulWidget {
  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'name': 'Kossuth Lajos utca', 'image': 'assets/images/street1.jpg', 'category': 'utca'},
    {'name': 'Petőfi Sándor utca', 'image': 'assets/images/street2.jpg', 'category': 'utca'},
    {'name': 'Bajcsy-Zsilinszky út', 'image': 'assets/images/street3.jpg', 'category': 'utca'},
    {'name': 'Rákóczi út', 'image': 'assets/images/street4.jpg', 'category': 'utca'},
    {'name': 'Széchenyi István tér', 'image': 'assets/images/street5.jpg', 'category': 'ter'},
  ];

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
              'assets/parking_h.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
                  Autocomplete<Map<String, String>>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Map<String, String>>.empty();
                      }
                      return _categories.where((category) => category['name']!
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (Map<String, String> option) => option['name']!,
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      _searchController.text = controller.text;
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          hintText: 'Street name',
                          hintStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(
                              Icons.location_on,
                              color: Colors.grey
                          ,size: 30,),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
                    onSelected: (Map<String, String> selectedCategory) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryListScreen(
                            categoryName: selectedCategory['category']!,
                            title: selectedCategory['name']!,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Find',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // PhotoView widget for zoomable image
                  SizedBox(
                    height: 260,
                    child: PhotoView(
                      imageProvider: AssetImage('assets/parking_map.jpg'),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      backgroundDecoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      heroAttributes: PhotoViewHeroAttributes(tag: 'uniqueTag'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
