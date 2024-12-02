import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'article.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open and create the database if it doesn't exist
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'bookmarks.db');

    return await openDatabase(
      path,
      version: 2, // Incremented version
      onCreate: (db, version) async {
        // Create the table for articles (bookmarks)
        await db.execute('''
          CREATE TABLE articles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            url TEXT,
            content TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Add the new 'content' column if upgrading
          await db.execute('ALTER TABLE articles ADD COLUMN content TEXT');
        }
      },
    );
  }

  // Insert an article into the database
  Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert('articles', article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all articles (bookmarks) from the database
  Future<List<Article>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');

    return List.generate(maps.length, (i) {
      return Article.fromMap(maps[i]);
    });
  }

  // Delete an article (bookmark) from the database
  Future<void> deleteArticle(String url) async {
    final db = await database;
    await db.delete('articles', where: 'url = ?', whereArgs: [url]);
  }
}