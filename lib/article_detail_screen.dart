import 'package:flutter/material.dart';
import 'article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  article.imageUrl,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              article.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              article.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  article.content ?? "No additional content available.",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
