import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            // Display article image if available
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

            // Display article description
            Text(
              article['description'] ?? 'No Description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Display article content
            Text(
              article['content'] ?? 'No Content',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),

            // Display article source
            Text(
              'Source: ${article['source']['name']}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Button to view the full article
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: Icon(Icons.link, color: Colors.white),
                label: Text(
                  "Read Full Article",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final url = article['url']; // Full article URL
                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false, // iOS-specific
                      forceWebView: true, // Open in browser
                      enableJavaScript: true, // Ensure modern JS compatibility
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Could not open the article."),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Button color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
