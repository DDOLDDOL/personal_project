import 'package:flutter/material.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/common/common.dart';

class UserRegistrationScreen extends StatelessWidget {
  const UserRegistrationScreen({
    super.key,
    // required this.user,
  });

  // final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              TextInputField(),
              TextInputField(),
              TextInputField(),
              const Spacer(),
              SubmitButton(
                onPressed: () {},
                child: const Text('등록하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
