import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'home_screen.dart';
import 'bookmark_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),  // Providing NewsProvider for the app
        ChangeNotifierProvider(create: (context) => BookmarkService()),  // Providing BookmarkService for managing bookmarks
      ],
      child: MaterialApp(
        title: 'Newsly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),  // HomeScreen as the main screen
      ),
    );
  }
}
