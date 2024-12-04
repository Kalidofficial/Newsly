import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article.dart';

class ApiService {
  final String _apiKey = '39b739d086c74d3b967343e21276ea39'; // API key
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Article>> fetchArticles(String category) async {
    final url = Uri.parse('$_baseUrl?category=$category&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Article> articles = [];
      for (var articleData in data['articles']) {
        articles.add(Article.fromJson(articleData));
      }
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}