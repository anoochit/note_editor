import 'package:flutter/material.dart';
import 'package:note_editor/note_editor.dart';

/// The main entry point of the application.
///
/// Initializes Flutter bindings and runs the [MyApp] widget.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// The root widget of the application.
///
/// Configures the MaterialApp with a default theme and sets [MyHomePage] as
/// the initial route.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Note Demo'),
    );
  }
}

/// A StatefulWidget that represents the main page of the application.
///
/// Manages the state for the note editor and associated tools.
class MyHomePage extends StatefulWidget {
  /// Creates a [MyHomePage] with the given [title].
  const MyHomePage({super.key, required this.title});

  /// The title displayed in the AppBar
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// The state class for [MyHomePage] that manages the note editor controller
/// and initializes note content.
class _MyHomePageState extends State<MyHomePage> {
  /// Controller for managing note editor content and operations
  NoteEditorController controller = NoteEditorController();

  @override
  void initState() {
    super.initState();
    initNoteItems();
  }

  /// Initializes the note with default items when the widget is first created.
  ///
  /// Adds a title item and a text item to demonstrate initial content.
  void initNoteItems() {
    controller.addItem(
      NoteItem(
        type: NoteItemType.title,
        text: 'Note Title',
      ),
    );
    controller.addItem(
      NoteItem(
        type: NoteItemType.text,
        text: 'Note text',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: NoteEditor(
              controller: controller,
            ),
          ),
          ToolBox(controller: controller),
        ],
      ),
    );
  }
}

/// A toolbar widget containing buttons to interact with the note editor.
///
/// Provides functionality to add new items, remove last item, and export
/// content to JSON format.
class ToolBox extends StatelessWidget {
  /// Creates a [ToolBox] with the given [controller].
  const ToolBox({
    super.key,
    required this.controller,
  });

  /// The controller used to manipulate the note editor content
  final NoteEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Button to add a new text item
          FilledButton.tonal(
            onPressed: () => controller.addItem(
              NoteItem(
                type: NoteItemType.text,
                text: '',
              ),
            ),
            child: const Text('Add'),
          ),
          // Button to remove the last item (keeps at least one item)
          FilledButton.tonal(
            onPressed: () {
              if (controller.items.length > 1) {
                controller.removeItem(controller.items.length - 1);
              }
            },
            child: const Text('Remove'),
          ),
          // Button to export content as JSON and display in dialog
          FilledButton.tonal(
            onPressed: () {
              final json = controller.exportToJson();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(json),
                ),
              );
            },
            child: const Text('Export'),
          )
        ],
      ),
    );
  }
}
