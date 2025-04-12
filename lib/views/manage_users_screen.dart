import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Список пользователей
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('role', isNotEqualTo: 'admin') // Исключаем администраторов
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Фильтрация по email
                final filteredUsers = snapshot.data!.docs.where((doc) {
                  final email = doc['email'].toString().toLowerCase();
                  return email.contains(_searchQuery);
                }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final userDoc = filteredUsers[index];
                    final userData = userDoc.data() as Map<String, dynamic>;
                    final user = UserModel.fromMap(userData);

                    return UserEditCard(
                      userId: userDoc.id,
                      email: user.email,
                      role: user.role,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserEditCard extends StatefulWidget {
  final String userId;
  final String email;
  final String role;

  const UserEditCard({
    required this.userId,
    required this.email,
    required this.role,
  });

  @override
  _UserEditCardState createState() => _UserEditCardState();
}

class _UserEditCardState extends State<UserEditCard> {
  late String _currentRole;

  @override
  void initState() {
    super.initState();
    _currentRole = widget.role;
  }

  Future<void> _saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'role': _currentRole,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating role: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.email,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Выбор роли
            DropdownButtonFormField<String>(
              value: _currentRole,
              onChanged: (value) {
                setState(() {
                  _currentRole = value!;
                });
              },
              items: ['user', 'teacher']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.capitalize()),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Role',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}