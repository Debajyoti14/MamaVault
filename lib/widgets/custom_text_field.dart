import 'package:flutter/material.dart';
import 'package:interrupt/config/color_pallete.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController? controller;
  final Function? onChanged;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final String? initialValue;
  final String hintText;
  final InputDecoration? decoration;
  final double? width;
  final double? height;
  final bool isNumber;
  const CustomTextField({
    super.key,
    this.obscureText = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    required this.hintText,
    this.controller,
    this.decoration,
    this.width,
    this.height,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: PalleteColor.primaryPurple),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: height ?? 7,
              horizontal: 13,
            ),
            hintText: hintText),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
