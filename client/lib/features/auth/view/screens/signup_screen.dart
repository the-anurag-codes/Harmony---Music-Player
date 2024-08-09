// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_loader.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/screens/login_screen.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_textfield.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));

    ref.listen(authViewModelProvider, (prev, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, 'Account created successfully! Please login');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LogInScreen()));
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
                        'Sign Up.',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        hintText: 'Name',
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
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
                        btnText: 'Sign Up',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signupUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text);
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
                                  builder: (context) => LogInScreen()));
                        },
                        child: RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                              TextSpan(
                                  text: 'Sign In',
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
