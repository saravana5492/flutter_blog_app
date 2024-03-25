import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.textInputType = TextInputType.name,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      cursorColor: AppPallete.gradient2,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      keyboardType: textInputType,
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return '$hintText is required!';
        }
        return null;
      },
    );
  }
}
