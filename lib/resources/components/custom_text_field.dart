import 'package:flutter/material.dart';
import 'package:interrupt/resources/colors.dart';

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
  final bool isPurple;
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
    this.isPurple = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        cursorColor: isPurple ? Colors.white : AppColors.primaryPurple,
        style:
            TextStyle(color: isPurple ? Colors.white : AppColors.primaryPurple),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isPurple ? Colors.white : AppColors.primaryPurple,
              width: isPurple ? 2 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isPurple ? Colors.white : AppColors.primaryPurple,
              width: isPurple ? 2 : 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: height ?? 7,
            horizontal: 13,
          ),
          hintText: hintText,
          labelStyle: TextStyle(
            color: isPurple ? Colors.white : AppColors.primaryPurple,
          ),
          hintStyle: TextStyle(
            color: isPurple ? Colors.white : AppColors.primaryPurple,
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
