import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const Input({Key? key, required this.onChanged, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        onChanged: onChanged,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF50524C),
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
