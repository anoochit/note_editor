import 'package:flutter/material.dart';

class NoteItemTitle extends StatelessWidget {
  const NoteItemTitle({
    super.key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onEnterPressed,
    required this.onEmpty,
    this.text,
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.headlineMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'New page',
        ),
        onSubmitted: (_) => onEnterPressed(),
        onChanged: (value) {
          if (value.isEmpty) {
            onEmpty();
          }
        },
      ),
    );
  }
}
