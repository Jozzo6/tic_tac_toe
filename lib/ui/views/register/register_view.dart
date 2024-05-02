import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/core/enums/view_state.dart';
import 'package:tic_tac_toe/ui/views/register/register_view_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _model = RegisterViewModel();
  final _formKey = GlobalKey<FormState>();

  void register() async {
    try {
      if (_formKey.currentState!.validate()) {
        await _model.register();
        Navigator.of(context).pushNamed('/login');
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

  void login() {
    Navigator.of(context).pushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<RegisterViewModel>.value(
          value: _model,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Register'),
              form(),
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Consumer<RegisterViewModel>(
      builder: (context, value, _) {
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
              value.state.value == ViewState.loading
                  ? SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    )
                  : ElevatedButton(
                      onPressed: register,
                      child: const Text('Register'),
                    ),
              TextButton(
                onPressed: login,
                child: const Text('Already have an account? Login'),
              )
            ],
          ),
        );
      },
    );
  }
}
