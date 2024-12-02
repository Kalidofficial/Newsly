import 'package:flutter/material.dart';
import 'news_provider.dart';
import 'article_card.dart';
import 'package:provider/provider.dart';
import 'news_search_screen.dart';
import 'bookmark_screen.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'business'; // Default category
  String _selectedSort = 'A-Z'; // Default sorting option (A-Z)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchNews(_selectedCategory, _selectedSort);
  }

  void _fetchNews(String category, String sortBy) {
    Provider.of<NewsProvider>(context, listen: false).fetchNews(category, sortBy);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Center(
            child: Text(
              'NEWSLY',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w300, // font
                fontSize: 24.0,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsSearchScreen()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text(
                  'Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
              ListTile(
                title: Text('Bookmarks'),
                leading: Icon(Icons.bookmark),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarksScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Category'),
                leading: Icon(Icons.category),
                subtitle: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String? newCategory) {
                    setState(() {
                      _selectedCategory = newCategory!;
                      _fetchNews(_selectedCategory, _selectedSort);
                    });
                  },
                  items: [
                    'business',
                    'entertainment',
                    'health',
                    'science',
                    'sports',
                    'technology',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Sort'),
                leading: Icon(Icons.sort),
                subtitle: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedSort,
                  underline: Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  onChanged: (String? newSort) {
                    setState(() {
                      _selectedSort = newSort!;
                      _fetchNews(_selectedCategory, _selectedSort);
                    });
                  },
                  items: [
                    'A-Z', // sorting option for A-Z
                    'Z-A', // sorting option for Z-A
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        body: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.articles.isEmpty) {
              return Center(child: Text("No articles available."));
            }
            return ListView.builder(
              itemCount: provider.articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: provider.articles[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return this.isEmpty ? this : this[0].toUpperCase() + this.substring(1);
  }
}
