// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_loader.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_textfield.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' as fpdart;

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _formKey.currentState?.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, 'LoggedIn successfully!');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? CustomLoader()
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Log In.',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        hintText: 'Email',
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                        btnText: 'Log In',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .loginUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                              TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Pallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ])),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
