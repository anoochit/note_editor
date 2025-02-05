import 'package:flutter/material.dart';
import 'package:note_editor/src/note_editor_type.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    this.type = NoteItemType.text,
    this.text,
    this.url,
    this.value,
  });

  final NoteItemType type;
  final String? text;
  final String? url;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(type.name),
    );
  }
}
