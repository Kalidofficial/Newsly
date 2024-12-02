import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_detail_screen.dart';

class NewsSearchScreen extends StatefulWidget {
  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  TextEditingController _controller = TextEditingController();
  List articles = [];
  List<int> bookmarkedArticles = []; // Track bookmarked articles by index
  bool isLoading = false;

  // Fetch news based on the search query
  Future<void> fetchArticles(String query) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=$query&apiKey=39b739d086c74d3b967343e21276ea39'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load articles');
    }
  }

  // Toggle bookmark
  void toggleBookmark(int index) {
    setState(() {
      if (bookmarkedArticles.contains(index)) {
        bookmarkedArticles.remove(index);
      } else {
        bookmarkedArticles.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search News',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
            color: Colors.red,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search for a News...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.red),
                    onPressed: () {
                      String query = _controller.text;
                      if (query.isNotEmpty) {
                        fetchArticles(query);
                      }
                    },
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    fetchArticles(query);
                  }
                },
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                bool isBookmarked = bookmarkedArticles.contains(index);
                return GestureDetector(
                  onTap: () {
                    // Navigate to SearchDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: NetworkImage(article['urlToImage'] ??
                                'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Title overlay
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          color: Colors.black54,
                          child: Text(
                            article['title'] ?? 'No Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Bookmark icon
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color:
                            isBookmarked ? Colors.red : Colors.black,
                          ),
                          onPressed: () => toggleBookmark(index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
