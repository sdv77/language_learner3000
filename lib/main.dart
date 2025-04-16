import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Загрузка переменных окружения
    await dotenv.load(fileName: ".env");

    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Запуск приложения
    runApp(MyApp());
  } catch (e) {
    print("Error initializing app: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LangLearner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Светлая тема
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(color: Colors.grey[100]) // Белый фон для всех экранов
      ),
      home: SplashScreen(), // Начальный экран — SplashScreen
    );
  }
}