import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "Delete",
  String cancelText = "Cancel",
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
      ],
    ),
  );
}
