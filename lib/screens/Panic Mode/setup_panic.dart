import 'package:flutter/material.dart';
import 'package:interrupt/widgets/custom_text_field.dart';
import 'package:interrupt/widgets/primary_button.dart';

import '../../config/UI_constraints.dart';

class SetupPanicScreen extends StatefulWidget {
  const SetupPanicScreen({super.key});

  @override
  State<SetupPanicScreen> createState() => _SetupPanicScreenState();
}

class _SetupPanicScreenState extends State<SetupPanicScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _phoneNumber3Controller = TextEditingController();

  String button1State = 'Initial';
  String button2State = 'Processing';
  String button3State = 'Approved';

  @override
  void dispose() {
    _phoneNumber1Controller.dispose();
    _phoneNumber2Controller.dispose();
    _phoneNumber3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Setup Panic Button',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 300,
                  child: Text(
                    'Add numbers to send them message in one click',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '+91',
                    style: TextStyle(fontSize: 20),
                  ),
                  CustomTextField(
                    hintText: 'Enter Phone Number',
                    controller: _phoneNumber1Controller,
                    width: 300,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                buttonTitle: 'Add',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Lessss gooooo');
                  }
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '+91',
                    style: TextStyle(fontSize: 20),
                  ),
                  CustomTextField(
                    hintText: 'Enter Phone Number',
                    controller: _phoneNumber2Controller,
                    width: 300,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                buttonTitle: 'Add',
                state: 'Processing',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Lessss gooooo');
                  }
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '+91',
                    style: TextStyle(fontSize: 20),
                  ),
                  CustomTextField(
                    hintText: 'Enter Phone Number',
                    controller: _phoneNumber3Controller,
                    width: 300,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                buttonTitle: 'Add',
                state: 'Approved',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Lessss gooooo');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
