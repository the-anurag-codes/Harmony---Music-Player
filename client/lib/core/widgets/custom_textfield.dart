import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.isObscureText = false,
      this.readOnly = false,
      this.validator,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscureText,
      validator: validator ??
          (val) {
            if (val!.trim().isEmpty) {
              return "$hintText is missing!";
            }
            return null;
          },
    );
  }
}
