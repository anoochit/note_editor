# Note Editor Widget for Flutter

A simple note text editor widget for Flutter (like Notion text editor). The widget has default heading for title and another content type eg: text, checkbox, image, video and audio. User can compose note,  adding NoteItem with content type to NoteEditor widget.

## Feature

* NoteEditor widget show as text form field.
* Compose note with NoteItem widget.
* Support many content type eg: text, checkbox, image, video and audio.
* Export your note in JSON format, so you can export to another type easily.

## How to use

Add package to pubspec.yaml

```yaml
dependencies:
  note_editor: ^1.0.0
```

Add NoteEditor widget to your app.

```dart
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
        title: Text('Editor Demo'),
      ),
      body: NoteEditor(
        controller: controller,
      ),
    );
  }
}
```

## Screenshots

| ![](/screenshots/screenshot01.png) | ![](/screenshots/screenshot02.png) |
| ---------------------------------- | ---------------------------------- |