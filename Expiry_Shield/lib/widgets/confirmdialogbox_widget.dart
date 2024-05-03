import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final Function onConfirm;

  const ConfirmDialog(
      {super.key, required this.message, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("No", style: TextStyle(fontSize: 18)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text(
            "Yes",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
