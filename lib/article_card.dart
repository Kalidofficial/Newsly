import 'package:flutter/material.dart';
import 'article.dart';
import 'database_helper.dart';
import 'article_detail_screen.dart';

class ArticleCard extends StatefulWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  // Check if the article is bookmarked when the card is initialized
  void _checkIfBookmarked() async {
    final dbHelper = DatabaseHelper();
    final bookmarks = await dbHelper.getArticles();
    setState(() {
      _isBookmarked = bookmarks.any((b) => b.url == widget.article.url);
    });
  }

  // Toggle the bookmark state
  void _toggleBookmark() async {
    final dbHelper = DatabaseHelper();

    if (_isBookmarked) {
      await dbHelper.deleteArticle(widget.article.url);
    } else {
      await dbHelper.insertArticle(widget.article);
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Bookmarked' : 'Removed from bookmarks',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ArticleDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: widget.article),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [

              widget.article.imageUrl.isNotEmpty
                  ? Image.network(
                widget.article.imageUrl,
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 200.0,
                color: Colors.grey.shade300,
                child: Icon(Icons.image, size: 80.0, color: Colors.grey),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Article title
                      Expanded(
                        child: Text(
                          widget.article.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Bookmark button
                      IconButton(
                        icon: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleBookmark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
