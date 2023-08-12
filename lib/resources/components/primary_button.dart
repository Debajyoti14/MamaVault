// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:interrupt/resources/colors.dart';

class PrimaryButton extends StatefulWidget {
  final String buttonTitle;
  final bool isLoading;
  final bool isPurple;

  final void Function() onPressed;
  const PrimaryButton({
    Key? key,
    required this.buttonTitle,
    this.isLoading = false,
    this.isPurple = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor:
              widget.isPurple ? Colors.white : AppColors.primaryPurple,
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        child: widget.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color:
                      widget.isPurple ? AppColors.primaryPurple : Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.buttonTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isPurple
                        ? AppColors.primaryPurple
                        : Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
