import 'package:flutter/material.dart';
import 'package:note_editor/note_editor.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, this.children, required this.controller});

  final NoteEditorController controller;
  final List<NoteItem>? children;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Hello, World!');
  }
}

class NoteEditorController {
  //
}
