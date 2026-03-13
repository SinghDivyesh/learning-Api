import 'package:flutter/material.dart';
import 'package:rest_api/models/user_model.dart';
import 'package:rest_api/services/api_services.dart';

import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> users = [];
  List<UserModel> filtersUsers = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      List<UserModel> Data = await ApiServices.fetchUsers();
      setState(() {
        users = Data;
        filtersUsers = Data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load";
        isLoading = false;
      });
    }
  }

  void SearchUser(String query) {
    setState(() {
      filtersUsers = users
          .where(
            (users) =>
                users.name.toLowerCase().contains(query.toLowerCase()) ||
                users.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
            icon: Icon(Icons.favorite_border),
            color: Colors.red,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(errorMessage, style: TextStyle(color: Colors.red)),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: SearchUser,
                    decoration: InputDecoration(
                      hintText: "Search by name or mail",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '{$filtersUsers.length } users found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtersUsers.length,
                    itemBuilder: (context, index) {
                      final user = filtersUsers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
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
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(user:user),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
