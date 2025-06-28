import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:web_scraping_flutter/advanced_bloc/features/login/presentation/cubit/login_cubit.dart';

import '../cubit/anther_away_states.dart';
import '../cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final sl = GetIt.instance;

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      context.read<LoginCubit>().login(email, password);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // لإجراء التحقق
            child: Column(
              children: [
                EmailTextField(controller: emailController),
                const SizedBox(height: 16),
                PasswordTextField(controller: passwordController),
                const SizedBox(height: 32),
                BlocListener<LoginCubit, UserLoginState>(
                  listener: (context, state) {
                    if (state.loginStatus.isLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login successful")),
                      );
                    } else if (state.loginStatus.isError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage.toString())),
                      );
                    }
                  },
                  child:  loginButton(
                    onPressed: () => _login(context),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget loginButton({required VoidCallback onPressed}) {
    return BlocBuilder<LoginCubit, UserLoginState>(
      buildWhen: (previous, current) =>
      current.loginStatus.isLoading ||  current.loginStatus.isLoaded ||  current.loginStatus.isError,
      builder: (context, state) {
        if (state.loginStatus.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        } else {
          return ElevatedButton(
            onPressed: onPressed,
            child: const Text("Login"),
          );
        }
      },
    );
  }
}

// ========== Email TextField Widget ==========
class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }
}

// ========== Password TextField Widget ==========
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}



