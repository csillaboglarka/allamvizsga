import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:allamvizsga/network/constants.dart' as constant;

class Article {
  final String title;
  final String content;
  final String date;
  final String description;
  final String imageUrl;
  final String category;

  Article({
    required this.title,
    required this.content,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class NewsScreen extends StatefulWidget {
  final String title;

  NewsScreen({
    Key? key,
    this.title = 'Valami',
  }) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> futureArticles;
  String selectedCategory = 'All';
  List<bool> expansionState = [];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.all_inbox_outlined},
    {'name': 'Local', 'icon': Icons.pin_drop_outlined},
    {'name': 'Culture', 'icon': Icons.theater_comedy_outlined},
    {'name': 'Sports', 'icon': Icons.sports_football},
  ];

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(
      Uri.parse("${constant.cim}news.php?category=$selectedCategory"),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Article> articles = jsonResponse.map((article) => Article.fromJson(article)).toList();

      expansionState = List.filled(articles.length, false);

      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Color(0xFFEBEBEB),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.blue,
                child: Column(
                  children: [
                    Text('News',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: categories.map((category) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category['name'];
                              futureArticles = fetchArticles();
                            });
                          },
                          child: Column(
                            children: [
                              Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(height: 5),
                              Text(
                                category['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Article>>(
                  future: futureArticles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildArticleList(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildArticleList(List<Article> articles) {
    List<Article> filteredArticles = articles.where((article) {
      return selectedCategory == 'All' || article.category == selectedCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Featured news',
            style: TextStyle(
              fontFamily: 'Graduate',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 150),
            itemCount: filteredArticles.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(filteredArticles[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredArticles[index].title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('yyyy-MM-dd').format(
                              DateTime.tryParse(filteredArticles[index].date) ??
                                  DateTime.now(),
                            ),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            filteredArticles[index].description,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: Text(
                                expansionState.length > index && expansionState[index]
                                    ? 'Close'
                                    : 'Read more',
                                style: TextStyle(color: Colors.white),
                              ),
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  if (expansionState.length > index) {
                                    expansionState[index] = expanded;
                                  }
                                });
                              },
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    filteredArticles[index].content,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
