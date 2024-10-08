import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimpleTextField extends StatelessWidget {
  SimpleTextField(
      {@required this.controller,
      this.labelText,
      this.errorText,
      this.suffixIcon,
      this.color,
      this.formKey,
      this.validator});

  final TextEditingController controller;
  final String labelText;
  final String errorText;
  final Icon suffixIcon;
  final Color color;
  final Key formKey;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      style: GoogleFonts.notoSans(),
      controller: controller,
      validator: validator,
      decoration: kTextFieldDecoration.copyWith(
        errorText: errorText,
        fillColor: color,
        contentPadding: EdgeInsets.symmetric(vertical: 3),
        labelText: labelText,
        prefixIcon: suffixIcon,
      ),
    );
  }
}
