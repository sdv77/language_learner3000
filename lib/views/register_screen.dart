import 'package:flutter/material.dart';
import 'package:language_learner3000/viewmodels/auth_viewmodel.dart';
import 'package:language_learner3000/widgets/auth_button.dart';
import 'package:language_learner3000/widgets/auth_text_field.dart'; // Adjust import path

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
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
      Navigator.pop(context); // Navigate back to login
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800], // Darker back arrow
        ),
      ),
      body: Center(
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
                      '✨', // Sparkle emoji
                      style: TextStyle(fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Join Us!',
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
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    onPressed: _register,
                    text: 'Register',
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _resendEmailVerification,
                    child: Text(
                      'Resend Verification Email',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}