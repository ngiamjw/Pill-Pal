import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  MyTextfield(
      {super.key,
      required this.hintText,
      required this.isPassword,
      required this.controller});

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Initialize based on isPassword
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null, // Show icon only if isPassword is true
      ),
      obscureText: _obscureText,
    );
  }
}
