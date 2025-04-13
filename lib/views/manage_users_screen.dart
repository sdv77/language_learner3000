import 'package:flutter/material.dart';
import '../viewmodels/admin_viewmodel.dart';
import '../models/user_model.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final AdminViewModel _adminViewModel = AdminViewModel();
  late Future<List<UserModel>> _usersFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usersFuture = _adminViewModel.getUsers();
  }

  Future<void> _searchUsers() async {
    setState(() {
      _usersFuture = _adminViewModel.searchUsers(_searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _usersFuture = _adminViewModel.getUsers();
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No users found.'));
                } else {
                  List<UserModel> users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      UserModel user = users[index];
                      return ListTile(
                        title: Text(user.email),
                        subtitle: Text('Role: ${user.role.capitalize()}'),
                        trailing: DropdownButton<String>(
                          value: user.role,
                          onChanged: (String? newRole) async {
                            if (newRole != null && newRole != user.role) {
                              await _adminViewModel.updateUserRole(user.uid, newRole);
                              setState(() {
                                _usersFuture = _adminViewModel.getUsers();
                              });
                            }
                          },
                          items: ['user', 'teacher'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role.capitalize()),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}