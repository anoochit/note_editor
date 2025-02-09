import 'package:flutter/material.dart';
import 'dart:convert';

import 'models/note_item.dart';
import 'widgets/note_text.dart';
import 'widgets/note_title.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, required this.controller});

  final NoteEditorController controller;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late List<NoteItem> items;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    items = widget.controller.items;
    controllers = widget.controller.controllers;
    focusNodes = widget.controller._focusNodes;
    widget.controller._setState = _updateState;
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    focusNodes.clear();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      items = widget.controller.items;
      controllers = widget.controller.controllers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(items.length, (index) {
        switch (items[index].type) {
          case NoteItemType.title:
            return NoteItemTitle(
              index: index,
              controller: controllers[index],
              text: items[index].text,
              focusNode: focusNodes[index],
              onEnterPressed: () => widget.controller.handleEnterPress(index),
              onEmpty: () => widget.controller.handleEmptyItem(index),
            );
          case NoteItemType.text:
            return NoteItemText(
              index: index,
              controller: controllers[index],
              text: items[index].text,
              focusNode: focusNodes[index],
              onEnterPressed: () => widget.controller.handleEnterPress(index),
              onEmpty: () => widget.controller.handleEmptyItem(index),
            );
          case NoteItemType.checkbox:
          case NoteItemType.link:
          case NoteItemType.image:
          case NoteItemType.video:
          case NoteItemType.audio:
            return const SizedBox(); // Placeholder for unimplemented types
        }
      }),
    );
  }
}

class NoteEditorController {
  List<NoteItem> items = [];
  List<TextEditingController> controllers = [];
  final List<FocusNode> _focusNodes = [];
  VoidCallback? _setState;

  void addItem(NoteItem noteItem) {
    items.add(noteItem);
    controllers.add(TextEditingController(text: noteItem.text));
    _focusNodes.add(FocusNode());
    _notifyListeners();
  }

  void handleEmptyItem(int index) {
    // Don't remove if it's the last item or if it's the title
    if (items.length <= 1 || items[index].type == NoteItemType.title) {
      return;
    }

    // Focus the previous item before removing the current one
    if (index > 0) {
      final previousFocusNode = _focusNodes[index - 1];
      final previousController = controllers[index - 1];

      // Set cursor to the end of the previous text
      previousController.selection = TextSelection.fromPosition(
        TextPosition(offset: previousController.text.length),
      );

      previousFocusNode.requestFocus();
    }

    // Remove the current item
    removeItem(index);
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      controllers[index].dispose();
      controllers.removeAt(index);
      _focusNodes[index].dispose();
      _focusNodes.removeAt(index);
      _notifyListeners();
    }
  }

  void handleEnterPress(int currentIndex) {
    // Create new text item
    addItem(NoteItem(
      type: NoteItemType.text,
      text: '',
    ));

    // Focus the new item
    Future.microtask(() {
      final newIndex = currentIndex + 1;
      if (newIndex < _focusNodes.length) {
        _focusNodes[newIndex].requestFocus();
      }
    });
  }

  void updateItem(int index, NoteItem noteItem) {
    if (index >= 0 && index < items.length) {
      items[index] = noteItem;
      controllers[index].text = noteItem.text;
      _notifyListeners();
    }
  }

  // Export all items as JSON string
  String exportToJson() {
    // Get current text from controllers
    List<NoteItem> currentItems = List.generate(items.length, (index) {
      return NoteItem(
        type: items[index].type,
        text: controllers[index].text, // Use current text from controller
      );
    });

    return jsonEncode({
      'items': currentItems.map((item) => item.toJson()).toList(),
    });
  }

  // Import items from JSON string
  void importFromJson(String jsonString) {
    try {
      // Clear existing items
      dispose();

      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> jsonItems = data['items'] as List;

      for (var jsonItem in jsonItems) {
        final noteItem = NoteItem.fromJson(jsonItem as Map<String, dynamic>);
        addItem(noteItem);
      }
    } catch (e) {
      debugPrint('Error importing JSON: $e');
    }
  }

  void listItems() {
    for (var i in items) {
      debugPrint('type > ${i.type}');
    }
  }

  void _notifyListeners() {
    _setState?.call();
  }

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    items.clear();
    controllers.clear();
  }
}
