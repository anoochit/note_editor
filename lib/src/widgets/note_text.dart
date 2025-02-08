import 'dart:developer';

import 'package:flutter/material.dart';

class NoteItemText extends StatelessWidget {
  const NoteItemText({
    super.key,
    required this.index,
    required this.controller,
    this.text,
    required this.focusNode,
    required this.onEnterPressed,
    required this.onEmpty,
  });

  final int index;
  final TextEditingController controller;
  final String? text;
  final FocusNode focusNode;
  final VoidCallback onEnterPressed;
  final VoidCallback onEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Write something...',
        ),
        maxLines: null,
        onSubmitted: (value) {
          onEnterPressed();
        },
        onChanged: (value) {
          if (value.endsWith('\n')) {
            controller.text = value.replaceAll('\n', '');
            onEnterPressed();
          }
          if (value.isEmpty) {
            log('delete');
            onEmpty();
          }
        },
      ),
    );
  }
}
