import 'package:flutter/material.dart';

class NoteItemText extends StatelessWidget {
  const NoteItemText({
    super.key,
    required this.index,
    required this.controller,
    this.text,
  });

  final int index;
  final TextEditingController controller;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'text',
        ),
        textInputAction: TextInputAction.next,
        maxLines: null,
      ),
    );
  }
}
