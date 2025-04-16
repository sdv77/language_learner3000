import 'package:flutter/material.dart'; // Adjust import path
import 'package:language_learner3000/viewmodels/auth_viewmodel.dart';
import 'package:language_learner3000/views/lessons_screen.dart';
import 'package:language_learner3000/views/register_screen.dart';
import 'package:language_learner3000/widgets/auth_button.dart';
import 'package:language_learner3000/widgets/auth_text_field.dart';

import '../views/teacher_screen.dart';
import '../views/admin_screen.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthViewModel _authViewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserModel? user = await _authViewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _getScreenByRole(user.role, user.uid),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during login: $e')),
      );
    }
  }

  Widget _getScreenByRole(String role, String userId) {
    switch (role) {
      case 'user':
        return LessonsScreen(userId: userId);
      case 'teacher':
        return TeacherScreen(userId: userId);
      case 'admin':
        return AdminScreen();
      default:
        return LessonsScreen(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    const Text(
                      '👋', // Waving hand emoji
                      style: TextStyle(fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Добро пожаловать!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800], // Darker text
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Эл. почта',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Пароль',
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    onPressed: _login,
                    text: 'Авторизоваться',
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Нету аккаунта? Зарегистрируйтесь',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
  )
    );
    
  }
}