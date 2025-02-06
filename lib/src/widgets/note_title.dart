import 'package:flutter/material.dart';

class NoteItemTitle extends StatelessWidget {
  const NoteItemTitle({
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.headlineMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
        ),
        textInputAction: TextInputAction.next,
        maxLines: null,
      ),
    );
  }
}
