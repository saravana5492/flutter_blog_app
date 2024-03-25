import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/snack_bar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: ((context) => const SignUpPage()));
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _signUpPressed() {
    context.read<AuthBloc>().add(
          AuthSignUp(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );
  }

  void _navigateToSignIn() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(
                        hintText: "Name",
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hintText: "Email",
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hintText: "Password",
                        controller: passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                        buttonTitle: "Sign up",
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _signUpPressed();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _navigateToSignIn,
                        child: RichText(
                          text: const TextSpan(
                            text: "Already have an account?  ",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign In. ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppPallete.gradient2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
