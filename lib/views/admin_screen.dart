import 'package:flutter/material.dart';
import 'manage_users_screen.dart';
import 'login_screen.dart';
import 'stats_screen.dart';
import 'logs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userName = currentUser?.email ?? 'Администратор';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Админ-панель',
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Аватар и приветствие
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepPurple[300]!,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 60,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Добро пожаловать, $userName!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF311B92),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Управляйте системой обучения',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Кнопки управления
                _buildAdminButton(
                  context: context,
                  icon: Icons.people_alt,
                  title: "Управление пользователями",
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                  ),
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => ManageUsersScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAdminButton(
                  context: context,
                  icon: Icons.analytics,
                  title: "Статистика системы",
                  gradient: LinearGradient(
                    colors: [Colors.purple[600]!, Colors.purple[400]!],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StatsScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAdminButton(
                  context: context,
                  icon: Icons.history,
                  title: "Логи изменений",
                  gradient: LinearGradient(
                    colors: [Colors.orange[600]!, Colors.orange[400]!],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LogsScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAdminButton(
                  context: context,
                  icon: Icons.logout,
                  title: "Выйти из системы",
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[400]!],
                  ),
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Подтверждение выхода",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Вы уверены, что хотите выйти из админ-панели?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отмена"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: const Text(
              "Выйти",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}