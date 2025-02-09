import 'package:flutter/material.dart';
import 'package:note_editor/note_editor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NoteEditorController controller = NoteEditorController();

  @override
  void initState() {
    super.initState();

    // Add some items
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

class ToolBox extends StatelessWidget {
  const ToolBox({
    super.key,
    required this.controller,
  });

  final NoteEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.tonal(
            onPressed: () => controller.addItem(
              NoteItem(
                type: NoteItemType.text,
                text: '',
              ),
            ),
            child: Text('add'),
          ),
          FilledButton.tonal(
            onPressed: () {
              if (controller.items.length > 1) {
                controller.removeItem(controller.items.length - 1);
              }
            },
            child: Text('remove'),
          ),
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
            child: Text('export'),
          )
        ],
      ),
    );
  }
}
