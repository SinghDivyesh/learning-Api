import 'package:flutter/material.dart';
import 'package:rest_api/models/user_model.dart';
import 'package:rest_api/storage/local_storage.dart';

class DetailScreen extends StatefulWidget {
  final UserModel user;
  const DetailScreen({super.key, required this.user});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFav = false;
  @override
  void iniState() {
    super.initState();
    isFav = LocalStorage.isFavorite(widget.user.id);
  }

  void toggleFavorite() async {
    if (isFav) {
      await LocalStorage.removeUser(widget.user.id);
    } else {
      await LocalStorage.saveUser(widget.user);
    }
    setState(() {
      isFav = !isFav;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav ? "Added to favorite!" : "Removed from Favorite!"),
        backgroundColor: isFav ? Colors.green : Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Text(
                widget.user.name[0],
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.user.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget infoTile(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
