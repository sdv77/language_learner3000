import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/home_screen.dart';
import '../views/teacher_screen.dart';
import '../views/admin_screen.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthViewModel _authViewModel = AuthViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
  try {
    UserModel? user = await _authViewModel.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      context, // Передаем контекст для отображения ошибок
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

  Future<void> _register() async {
    try {
      await _authViewModel.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        'user',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account registered! Please verify your email.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration: $e')),
      );
    }
  }

  Future<void> _resendEmailVerification() async {
    try {
      await _authViewModel.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent! Check your inbox.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending verification email: $e')),
      );
    }
  }

  Widget _getScreenByRole(String role, String userId) {
    switch (role) {
      case 'user':
        return HomeScreen(userId: userId);
      case 'teacher':
        return TeacherScreen(userId: userId);
      case 'admin':
        return AdminScreen();
      default:
        return HomeScreen(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: _resendEmailVerification,
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}