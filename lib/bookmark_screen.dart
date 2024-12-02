import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'article.dart';
import 'article_card.dart';

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: DatabaseHelper().getArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookmarked articles.'));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return ArticleCard(article: articles[index]);
            },
          );
        },
      ),
    );
  }
}
