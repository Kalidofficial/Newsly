import 'package:flutter/material.dart';

class SearchDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  SearchDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'] ?? 'Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [

            article['urlToImage'] != null
                ? Image.network(
              article['urlToImage'],
              fit: BoxFit.cover,
            )
                : Container(),
            SizedBox(height: 8),
            // Display article title
            Text(
              article['title'] ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              article['description'] ?? 'No Description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            Text(
              article['content'] ?? 'No Content',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),

            Text(
              'Source: ${article['source']['name']}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
