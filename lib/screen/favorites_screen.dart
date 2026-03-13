// This file answers: "What does the favorites screen look like?"

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../storage/local_storage.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  List<UserModel> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() {
    setState(() {
      favorites = LocalStorage.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.red,
      ),
      body: favorites.isEmpty

      // Empty state
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Tap ❤️ on any user to save them',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )

      // Show favorites list
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final user = favorites[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  user.name[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
              trailing: Icon(Icons.favorite, color: Colors.red, size: 20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(user: user),
                  ),
                ).then((_) => loadFavorites()); // refresh after coming back
              },
            ),
          );
        },
      ),
    );
  }
}