import 'package:flutter/material.dart';
import 'package:pi_app/app/styles/styles.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final RichText content;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Icon customIcon;

  const ConfirmDialog({super.key, 
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    required this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          customIcon,
          const SizedBox(width: 10),
          Text(
            title,
            style: Styles.titulo,
          ),
        ],
      ),
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelButtonText,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmButtonText,
            style: TextStyle(
              color: Colors.red[400],
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
