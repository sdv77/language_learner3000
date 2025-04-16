import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Отступы вокруг всего нижнего меню
        child: Card(
          elevation: 4, // Добавляем тень для карточки
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Закругляем края карточки
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16), // Закругляем края содержимого
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Уроки',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Завершенные',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: onTap,
              backgroundColor: Colors.white, // Фон внутри нижней панели
            ),
          ),
        ),
      ),
    );
  }
}