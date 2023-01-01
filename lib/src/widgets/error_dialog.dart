
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text('An error occurred'),
            content: Text(text),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ));
}
