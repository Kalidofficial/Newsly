class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String? content;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    this.content,
  });

  /// Factory constructor to create an `Article` from a JSON response
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      content: json['content'],
    );
  }


  String? get getContent => content;

  /// Method to convert `Article` to a Map (for SQLite storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'url': url,
      'content': content,
    };
  }

  /// Factory constructor to create an `Article` from a Map (SQLite query result)
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      url: map['url'],
      content: map['content'],
    );
  }

  /// Method to get a formatted string representation of the article
  @override
  String toString() {
    return 'Article(title: $title, description: $description, imageUrl: $imageUrl, url: $url, content: $content)';
  }
}
