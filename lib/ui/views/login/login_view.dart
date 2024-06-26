import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/ui/views/login/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _model = LoginViewModel();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    try {
      if (_formKey.currentState!.validate()) {
        await _model.login();
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red[300],
        ),
      );
    }
  }

  void register() {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<LoginViewModel>.value(
          value: _model,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login'),
              form(),
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Consumer<LoginViewModel>(
      builder: (context, value, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value.state.value == ViewState.success) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        });
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  _model.username.value = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  _model.password.value = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              if (value.state.value == ViewState.loading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Login'),
                ),
              TextButton(
                onPressed: register,
                child: const Text('Don\'t have an account? Register'),
              )
            ],
          ),
        );
      },
    );
  }
}
