import 'package:flutter/material.dart';
import 'package:note_editor/note_editor.dart';

void main() {
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  NoteEditorController noteEditorController = NoteEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: NoteEditor(
        controller: noteEditorController,
        children: [
          NoteItem(
            type: NoteItemType.title,
            text: 'Note title',
          ),
          NoteItem(
            type: NoteItemType.text,
            text: 'Note text here',
          ),
          NoteItem(
            type: NoteItemType.checkbox,
            text: 'Task 1',
            value: false,
          ),
          NoteItem(
            type: NoteItemType.link,
            url: 'https://github.com/anoochit',
          ),
          NoteItem(
            type: NoteItemType.image,
            url:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/640px-Google_2015_logo.svg.png',
          ),
          NoteItem(
            type: NoteItemType.video,
            url:
                'http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_60fps_normal.mp4',
          ),
          NoteItem(
            type: NoteItemType.audio,
            url: '',
          ),
        ],
      ),
    );
  }
}
