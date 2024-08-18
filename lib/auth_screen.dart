import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/widgets/auth_button.dart';
import 'package:yoto/widgets/custome_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final email = emailController.text.trim();
        final password = passController.text.trim();
        final authStore = Provider.of<AuthStore>(context, listen: false);

        if (isLogin) {
          await authStore.signIn(email, password);
        } else {
          await authStore.signUp(email, password);
        }

        Navigator.of(context).pushReplacementNamed('/');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: isDarkMode
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          validator: authStore.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: passController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: authStore.validatePassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    text: isLogin ? 'Log In' : 'Sign Up',
                    onPressed: _submitForm,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      isLogin
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Log In',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
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
