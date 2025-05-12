// stats_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart'; // Для форматирования дат

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late Future<List<UserModel>> futureUsers;
  List<UserModel> users = [];

  final List<String> months = [
    'Янв',
    'Фев',
    'Мар',
    'Апр',
    'Май',
    'Июн',
    'Июл',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек'
  ];

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final List<UserModel> userList = snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
    setState(() {
      users = userList;
    });
    return userList;
  }

  int getTotalByRole(String role) {
    return users.where((user) => user.role == role).length;
  }

  List<UserModel> getTopStudents(int count) {
    List<UserModel> students = users.where((user) => user.role == 'user').toList();
    students.sort((a, b) => b.completedLessonsCount.compareTo(a.completedLessonsCount));
    return students.take(count).toList();
  }

  Map<String, int> getUsersByMonth(List<UserModel> usersList) {
    final Map<String, int> stats = {};
    for (var user in usersList) {
      if (user.createdAt != null) {
        final month = "${user.createdAt.year}-${user.createdAt.month}";
        stats[month] = (stats[month] ?? 0) + 1;
      }
    }
    return stats;
  }

  Color getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.deepPurple.shade500;
      case 'teacher':
        return Colors.blue.shade600;
      default:
        return Colors.green.shade600;
    }
  }

  Widget buildStatCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              '$count',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Статистика системы',
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
              setState(() {
                futureUsers = fetchUsers();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Ошибка загрузки данных"));
          }

          final totalUsers = snapshot.data!.length;
          final students = getTotalByRole('user');
          final teachers = getTotalByRole('teacher');
          final admins = getTotalByRole('admin');

          final topStudents = getTopStudents(5);

          final now = DateTime.now();
          final currentYear = now.year;

          final registrationStats = getUsersByMonth(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    buildStatCard('Всего', totalUsers, Colors.blue),
                    SizedBox(width: 10),
                    buildStatCard('Ученики', students, Colors.green),
                    SizedBox(width: 10),
                    buildStatCard('Учителя', teachers, Colors.orange),
                    SizedBox(width: 10),
                    buildStatCard('Админы', admins, Colors.deepPurple),
                  ],
                ),
                SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Регистрации по месяцам за год',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final monthIndex = value.toInt() % 12;
                                      final label = '${months[monthIndex]} $currentYear';
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            label,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: List<BarChartGroupData>.generate(12, (index) {
                                final key = "$currentYear-${index + 1}";
                                final count = registrationStats[key] ?? 0;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: count.toDouble(),
                                      color: Colors.blue,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Топ учеников по пройденным урокам',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        for (var i = 0; i < topStudents.length; i++)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Text('${i + 1}', style: TextStyle(color: Colors.green.shade800)),
                            ),
                            title: Text(topStudents[i].email),
                            subtitle: Text('${topStudents[i].completedLessonsCount} пройденных уроков'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}