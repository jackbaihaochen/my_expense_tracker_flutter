import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_expense_tracker/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool _isLogin = true;
  String _email = '';
  String _password = '';

  void onLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) {
          return;
        }
        showSnackBar(context, e.message ?? 'Authentication Failed');
      }
    }
  }

  void onRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        await auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (!context.mounted) {
          return;
        }
        showSnackBar(context, 'User Created Successfully');
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) {
          return;
        }
        showSnackBar(context, e.message ?? 'Create User Failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Login' : 'Register',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter email correctly.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter password correctly.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 46.0),
              _isLogin
                  ? ElevatedButton(
                      onPressed: onLogin,
                      child: const Text('Login'),
                    )
                  : ElevatedButton(
                      onPressed: onRegister,
                      child: const Text('Register'),
                    ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: _isLogin
                    ? const Text('Go To Register')
                    : const Text('Go To Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
