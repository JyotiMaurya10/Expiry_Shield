import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final Function onConfirm;

  const ConfirmDialog({Key? key, required this.message, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message,style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("No",style: TextStyle(fontSize: 18)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            onConfirm();
          },
          child: const Text("Yes",style: TextStyle(fontSize: 18),),
        ),
      ],
    );
  }
}
