import 'package:flutter/material.dart';

/// A widget that displays an editable title field for a note or page.
///
/// This widget provides a text field styled as a headline, suitable for titles
/// or headers in a note-taking application. It handles user input events such
/// as submissions and empty states.
///
/// Example usage:
/// ```dart
/// NoteItemTitle(
///   index: 0,
///   controller: TextEditingController(),
///   focusNode: FocusNode(),
///   onEnterPressed: () => print('Enter pressed'),
///   onEmpty: () => print('Title is empty'),
/// )
/// ```
class NoteItemTitle extends StatelessWidget {
  /// Creates a [NoteItemTitle] widget.
  ///
  /// * [index] represents the position of this title in a list.
  /// * [controller] manages the text input state.
  /// * [focusNode] manages the focus state of the text field.
  /// * [onEnterPressed] is called when the user submits the title.
  /// * [onEmpty] is called when the title field becomes empty.
  /// * [text] is the initial text content (optional).
  const NoteItemTitle({
    super.key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onEnterPressed,
    required this.onEmpty,
    this.text,
  });

  /// The index of this title in a list.
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
