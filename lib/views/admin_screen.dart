import 'package:flutter/material.dart';
import 'manage_users_screen.dart';
import 'login_screen.dart';

// Цветовая палитра (заменители для .shade)
const Color deepPurple50 = Color(0xFFEDE7F6);
const Color deepPurple100 = Color(0xFFD1C4E9);
const Color deepPurple200 = Color(0xFFB39DDB);
const Color deepPurple300 = Color(0xFF9575CD);
const Color deepPurple400 = Color(0xFF7E57C2);
const Color deepPurple500 = Color(0xFF673AB7);
const Color deepPurple800 = Color(0xFF4527A0);
const Color blue50 = Color(0xFFE3F2FD);
const Color red50 = Color(0xFFFFEBEE);
const Color red100 = Color(0xFFFFCDD2);
const Color red800 = Color(0xFFC62828);
const Color grey400 = Color(0xFFBDBDBD);

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ-панель', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: deepPurple500,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [deepPurple50, blue50],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Аватарка админа
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: deepPurple100,
                  shape: BoxShape.circle,
                  border: Border.all(color: deepPurple500, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: deepPurple400.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.admin_panel_settings, 
                  size: 60, 
                  color: deepPurple500),
              ),
              const SizedBox(height: 30),
              
              // Приветствие
              const Text('Добро пожаловать, Администратор!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: deepPurple800),
              ),
              const SizedBox(height: 10),
              const Text('Управляйте системой обучения',
                style: TextStyle(
                  fontSize: 16,
                  color: grey400),
              ),
              const SizedBox(height: 40),
              
              // Кнопка управления пользователями
              _buildAdminButton(
                context: context,
                icon: Icons.people,
                title: "Управление пользователями",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageUsersScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              
              // Кнопка выхода
              _buildAdminButton(
                context: context,
                icon: Icons.exit_to_app,
                title: "Выйти",
                color: red50,
                iconColor: Colors.red,
                textColor: red800,
                onTap: () {
                  _confirmLogout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
    Color iconColor = deepPurple500,
    Color textColor = deepPurple800,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: deepPurple200.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: color == Colors.white 
                ? deepPurple100 
                : red100,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color == Colors.white
                    ? deepPurple50
                    : red50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: iconColor.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Подтверждение выхода"),
          content: const Text("Вы уверены, что хотите выйти из админ-панели?"),
          actions: [
            TextButton(
              child: const Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Выйти", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}