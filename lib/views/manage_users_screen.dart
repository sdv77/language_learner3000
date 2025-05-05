import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final List<String> completedLessons;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.completedLessons,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    final role = data.containsKey('role') 
        ? data['role'].toString()
        : 'user';
    
    return UserModel(
      uid: data['uid']?.toString() ?? doc.id,
      email: data['email']?.toString() ?? 'No email',
      role: role,
      completedLessons: List<String>.from(data['completedLessons'] ?? []),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    List<String>? completedLessons,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      completedLessons: completedLessons ?? this.completedLessons,
    );
  }
}

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  
  List<UserModel> _users = [];
  bool _isLoading = true;
  String _selectedRole = 'all';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Ошибка загрузки: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки пользователей'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  List<UserModel> _getFilteredUsers() {
    return _users.where((user) {
      final searchText = _searchController.text.toLowerCase();
      final matchesSearch = user.email.toLowerCase().contains(searchText);
      final matchesRole = _selectedRole == 'all' || user.role == _selectedRole;
      return matchesSearch && matchesRole;
    }).toList();
  }

  Future<void> _updateUserRole(String userId, String newRole) async {
    try {
      const validRoles = ['user', 'teacher', 'admin'];
      if (!validRoles.contains(newRole)) {
        throw Exception('Недопустимая роль');
      }

      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });

      setState(() {
        final index = _users.indexWhere((user) => user.uid == userId);
        if (index != -1) {
          _users[index] = _users[index].copyWith(role: newRole);
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Роль успешно изменена'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print('Ошибка изменения роли: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildRoleChip(String role) {
    final color = role == 'admin'
        ? Colors.deepPurple
        : role == 'teacher'
            ? Colors.blue
            : Colors.green;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        role == 'admin'
            ? 'Админ'
            : role == 'teacher'
                ? 'Учитель'
                : 'Студент',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredUsers();
    final teacherCount = _users.where((u) => u.role == 'teacher').length;
    final adminCount = _users.where((u) => u.role == 'admin').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Управление пользователями',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _animationController.reset();
              _animationController.forward();
              _loadUsers();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Поиск пользователей',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilterChip(
                              label: Text('Все'),
                              selected: _selectedRole == 'all',
                              onSelected: (_) => setState(() => _selectedRole = 'all'),
                            ),
                            SizedBox(width: 8),
                            FilterChip(
                              label: Text('Студенты'),
                              selected: _selectedRole == 'user',
                              onSelected: (_) => setState(() => _selectedRole = 'user'),
                            ),
                            SizedBox(width: 8),
                            FilterChip(
                              label: Text('Учителя'),
                              selected: _selectedRole == 'teacher',
                              onSelected: (_) => setState(() => _selectedRole = 'teacher'),
                            ),
                            SizedBox(width: 8),
                            FilterChip(
                              label: Text('Админы'),
                              selected: _selectedRole == 'admin',
                              onSelected: (_) => setState(() => _selectedRole = 'admin'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard('Всего', _users.length, Colors.blue),
                  SizedBox(width: 10),
                  _buildStatCard('Учителя', teacherCount, Colors.green),
                  SizedBox(width: 10),
                  _buildStatCard('Админы', adminCount, Colors.deepPurple),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredUsers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people_alt_outlined, size: 60, color: Colors.grey.shade300),
                              SizedBox(height: 16),
                              Text(
                                'Пользователи не найдены',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(Icons.person, color: Colors.blue.shade800),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          _buildRoleChip(user.role),
                                          if (user.role == 'user') ...[
                                            SizedBox(height: 4),
                                            LinearProgressIndicator(
                                              value: user.completedLessons.length / 20,
                                              backgroundColor: Colors.grey.shade200,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Пройдено уроков: ${user.completedLessons.length}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert),
                                      onSelected: (newRole) => _updateUserRole(user.uid, newRole),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'user',
                                          child: Text('Сделать студентом'),
                                        ),
                                        PopupMenuItem(
                                          value: 'teacher',
                                          child: Text('Сделать учителем'),
                                        ),
                                        PopupMenuItem(
                                          value: 'admin',
                                          child: Text('Сделать админом'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}