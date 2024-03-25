import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/snack_bar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _signInPressed() {
    context.read<AuthBloc>().add(
          AuthSignIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(SignUpPage.route());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign In.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                    buttonTitle: "Sign In",
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        _signInPressed();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account?  ",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up.",
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
            );
          },
        ),
      ),
    );
  }
}
