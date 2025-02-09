class NoteItem {
  final NoteItemType type;
  final String text;

  NoteItem({required this.type, required this.text});

  // Convert NoteItem to Map
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'text': text,
    };
  }

  // Create NoteItem from Map
  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      type: NoteItemType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NoteItemType.text,
      ),
      text: json['text'] as String,
    );
  }
}

// note item type
enum NoteItemType {
  title,
  text,
  checkbox,
  link,
  image,
  video,
  audio,
}

// note font style
enum NoteFontStyle {
  sans,
  serif,
  monospace,
}
