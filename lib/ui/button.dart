import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? icon;

  const Button(
      {required this.title, required this.onPressed, this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFFBFE6BC)),
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
        ),
        icon: icon ?? const SizedBox.shrink(),
        label: Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
