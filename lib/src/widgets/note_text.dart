import 'dart:developer';

import 'package:flutter/material.dart';

/// A customizable text input widget designed for note-taking applications.
///
/// This widget provides a text field that responds to user input with specific
/// behaviors for note management, such as handling enter key presses and empty
/// states.
///
/// Example usage:
/// ```dart
/// NoteItemText(
///   index: 0,
///   controller: TextEditingController(),
///   focusNode: FocusNode(),
///   onEnterPressed: () => print('Enter pressed'),
///   onEmpty: () => print('Field is empty'),
/// )
/// ```
class NoteItemText extends StatelessWidget {
  /// Creates a [NoteItemText] widget.
  ///
  /// * [index] represents the position of this note item in a list.
  /// * [controller] manages the text input state.
  /// * [text] is the initial text content (optional).
  /// * [focusNode] manages the focus state of the text field.
  /// * [onEnterPressed] is called when the user presses enter or submits the text.
  /// * [onEmpty] is called when the text field becomes empty.
  const NoteItemText({
    super.key,
    required this.index,
    required this.controller,
    this.text,
    required this.focusNode,
    required this.onEnterPressed,
    required this.onEmpty,
  });

  /// The index of this note item in a list.
  final int index;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// The initial text to be displayed (optional).
  final String? text;

  /// Controls the focus state of the text field.
  final FocusNode focusNode;

  /// Callback function triggered when enter is pressed or text is submitted.
  final VoidCallback onEnterPressed;

  /// Callback function triggered when the text field becomes empty.
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
