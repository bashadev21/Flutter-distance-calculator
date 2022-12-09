import 'package:distancecalcy/constants.dart';
import 'package:flutter/material.dart';

class UserInputView extends StatefulWidget {
  const UserInputView({super.key});

  @override
  State<UserInputView> createState() => _UserInputViewState();
}

class _UserInputViewState extends State<UserInputView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgrounColor,
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text('Choose vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
    );
  }
}
