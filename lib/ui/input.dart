import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? labelText;
  final String? errorText;

  const Input(
      {Key? key,
      required this.onChanged,
      this.hintText,
      this.errorText,
      this.labelText,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          filled: true,
          fillColor: const Color(0xFF50524C),
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
