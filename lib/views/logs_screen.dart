import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'История изменений ролей',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4527A0),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('role_change_logs')
              .orderBy('changeDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 20),
                    Text(
                      'Ошибка загрузки логов',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple[900],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4527A0)),
                ),
              );
            }

            final logs = snapshot.data!.docs;

            if (logs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, 
                        color: Colors.grey[400], size: 60),
                    const SizedBox(height: 20),
                    Text(
                      'Нет данных об изменениях',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index].data() as Map<String, dynamic>;
                final newRole = log['newRole'] ?? 'user';
                final oldRole = log['oldRole'] ?? 'user';
                
                Color getRoleColor(String role) {
                  switch (role) {
                    case 'admin': return const Color(0xFF4527A0);
                    case 'teacher': return Colors.blue;
                    default: return Colors.green;
                  }
                }

                String getRoleName(String role) {
                  switch (role) {
                    case 'admin': return 'Админ';
                    case 'teacher': return 'Учитель';
                    default: return 'Студент';
                  }
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                log['userEmail'] ?? 'Неизвестный пользователь',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.person, color: Colors.deepPurple[300]),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: getRoleColor(oldRole).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: getRoleColor(oldRole),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                getRoleName(oldRole),
                                style: TextStyle(
                                  color: getRoleColor(oldRole),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, 
                                color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: getRoleColor(newRole).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: getRoleColor(newRole),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                getRoleName(newRole),
                                style: TextStyle(
                                  color: getRoleColor(newRole),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person_outline, 
                                color: Colors.grey[600], size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Изменил: ${log['changedBy'] ?? 'system'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, 
                                color: Colors.grey[600], size: 16),
                            const SizedBox(width: 8),
                            Text(
                              log['formattedDate'] ?? 
                                  DateFormat('dd.MM.yyyy HH:mm')
                                      .format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}