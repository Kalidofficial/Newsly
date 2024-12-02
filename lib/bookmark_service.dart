import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'article.dart';

class BookmarkService extends ChangeNotifier {
  Database? _database;

  // Initialize the database
  Future<void> _initDatabase() async {
    if (_database != null) return;

    String path = join(await getDatabasesPath(), 'bookmarks.db');
    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bookmarks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, imageUrl TEXT, url TEXT)',
        );
      },
      version: 1,
    );
  }

  // Add a bookmark
  Future<void> addBookmark(Article article) async {
    await _initDatabase();

    await _database?.insert(
      'bookmarks',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  // Remove a bookmark
  Future<void> removeBookmark(int id) async {
    await _initDatabase();

    await _database?.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );

    notifyListeners();
  }

  // Fetch all bookmarks
  Future<List<Article>> fetchBookmarks() async {
    await _initDatabase();

    final List<Map<String, dynamic>> maps = await _database!.query('bookmarks');

    return List.generate(maps.length, (i) {
      return Article(
        title: maps[i]['title'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
        url: maps[i]['url'],
      );
    });
  }

  // Check if an article is bookmarked
  Future<bool> isBookmarked(int id) async {
    await _initDatabase();

    final List<Map<String, dynamic>> maps = await _database!.query(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty;
  }
}
