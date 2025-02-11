import 'package:flutter/material.dart';
import 'dart:convert';

import 'models/note_item.dart';
import 'widgets/note_text.dart';
import 'widgets/note_title.dart';

/// A widget that provides a rich text editor for creating and editing notes.
///
/// The editor supports different types of note items such as titles, text blocks,
/// and (planned support for) checkboxes, links, images, videos, and audio.
/// It uses a [NoteEditorController] to manage the state and operations of the editor.
class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, required this.controller});

  /// The controller that manages the state and operations of the note editor.
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

/// Controller class for managing the state and operations of a [NoteEditor].
///
/// This controller handles all the logic for adding, removing, and updating note items,
/// as well as managing focus and text input. It also provides functionality for
/// importing and exporting notes as JSON.
class NoteEditorController {
  /// List of note items in the editor
  List<NoteItem> items = [];

  /// List of text controllers for each note item
  List<TextEditingController> controllers = [];

  /// List of focus nodes for managing keyboard focus
  final List<FocusNode> _focusNodes = [];

  /// Callback to trigger state updates in the editor widget
  VoidCallback? _setState;

  /// Adds a new note item to the editor.
  ///
  /// Creates corresponding text controller and focus node for the item.
  /// Notifies listeners of the change.
  void addItem(NoteItem noteItem) {
    items.add(noteItem);
    controllers.add(TextEditingController(text: noteItem.text));
    _focusNodes.add(FocusNode());
    _notifyListeners();
  }

  /// Handles when a note item becomes empty (e.g., when user deletes all text).
  ///
  /// If the item is not the last one or the title, removes it and focuses the previous item.
  /// Does nothing if it's the last item or the title item.
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

  /// Removes a note item at the specified index.
  ///
  /// Disposes of the corresponding text controller and focus node.
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

  /// Handles when the Enter key is pressed in a note item.
  ///
  /// Creates a new text item below the current one and focuses it.
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

  /// Updates an existing note item at the specified index.
  ///
  /// Updates both the item data and its text controller.
  void updateItem(int index, NoteItem noteItem) {
    if (index >= 0 && index < items.length) {
      items[index] = noteItem;
      controllers[index].text = noteItem.text;
      _notifyListeners();
    }
  }

  /// Exports all note items as a JSON string.
  ///
  /// The exported JSON includes the current text from all controllers.
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

  /// Imports note items from a JSON string.
  ///
  /// Clears existing items before importing. Prints an error message if the import fails.
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

  /// Prints the type of each note item to the debug console.
  void listItems() {
    for (var i in items) {
      debugPrint('type > ${i.type}');
    }
  }

  /// Notifies listeners of state changes.
  void _notifyListeners() {
    _setState?.call();
  }

  /// Disposes of all controllers and clears the items list.
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    items.clear();
    controllers.clear();
  }
}
