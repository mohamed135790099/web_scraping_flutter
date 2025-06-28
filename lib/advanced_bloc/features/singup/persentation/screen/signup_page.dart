import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final sl = GetIt.instance;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
        create: (_) => sl(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Signup Page'),
          ),
          body:BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) {
              final bloc = context.read<SignupBloc>();
              return Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        errorText: state.fullNameError,
                      ),
                      onChanged: (value) => bloc.add(ChangeFullNameEvent(value)),
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: state.emailError,
                      ),
                      onChanged: (value) => bloc.add(ChangeEmailEvent(value)),
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: state.passwordError,
                      ),
                      obscureText: true,
                      onChanged: (value) => bloc.add(ChangePasswordEvent(value)),
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        errorText: state.confirmPasswordError,
                      ),
                      obscureText: true,
                      onChanged: (value) => bloc.add(ChangeConfirmPasswordEvent(value)),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          bloc.add(ChangeProfileImageEvent(image));
                        }
                      },
                      child: const Text('Select Profile Image'),
                    ),
                    if (state.profileImageError != null)
                      Text(
                        state.profileImageError!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: state.isValid
                          ? () => bloc.add(const SignupSubmittedEvent())
                          : null,
                      child: state.status == SingUpStatus.loading
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up'),
                    ),
                  ],
                ),
              );
            },
          ),
        )
    );
  }
}
