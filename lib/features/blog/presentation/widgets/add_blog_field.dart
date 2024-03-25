import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AddBlogField extends StatelessWidget {
  const AddBlogField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      cursorColor: AppPallete.gradient2,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return '$hintText is required!';
        }
        return null;
      },
    );
  }
}
