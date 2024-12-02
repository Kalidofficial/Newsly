import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article.dart';

class NewsProvider with ChangeNotifier {
  List<Article> articles = [];
  bool isLoading = false;

  // Fetch news with sorting logic
  Future<void> fetchNews(String category, String sortBy) async {
    final url =
        'https://newsapi.org/v2/top-headlines?category=$category&apiKey=39b739d086c74d3b967343e21276ea39';

    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);


        articles = (data['articles'] as List)
            .map((articleData) => Article.fromJson(articleData))
            .toList();

        // Apply sorting if necessary
        _applySorting(sortBy);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print('Error fetching news: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Sort articles based on the selected sort option
  void _applySorting(String sortBy) {
    switch (sortBy) {
      case 'A-Z':
        articles.sort((a, b) => a.title.compareTo(b.title)); // Sort by title A-Z
        break;
      case 'Z-A':
        articles.sort((a, b) => b.title.compareTo(a.title)); // Sort by title Z-A
        break;

      default:

        articles.sort((a, b) => a.title.compareTo(b.title)); // Default: Sort by title A-Z
        break;
    }
  }
}
