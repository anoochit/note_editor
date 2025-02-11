/// Represents a single item within a note, which can be of various types like
/// text, checkbox, media, etc.
///
/// Each [NoteItem] consists of:
/// * [type] - The type of the note item (e.g., title, text, checkbox)
/// * [text] - The actual content of the note item
class NoteItem {
  /// Specifies the type of the note item (e.g., title, text, checkbox)
  final NoteItemType type;

  /// The actual content or text of the note item
  final String text;

  /// Creates a new [NoteItem] with the specified [type] and [text]
  ///
  /// Both [type] and [text] parameters are required.
  NoteItem({required this.type, required this.text});

  /// Converts the [NoteItem] instance to a JSON-compatible Map
  ///
  /// Returns a Map with 'type' and 'text' keys where:
  /// * 'type' is the string representation of the [NoteItemType]
  /// * 'text' is the content string
  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'text': text,
    };
  }

  /// Creates a [NoteItem] instance from a JSON Map
  ///
  /// Parameters:
  /// * [json] - A Map containing 'type' and 'text' keys
  ///
  /// Returns a new [NoteItem] instance. If the type is not recognized,
  /// defaults to [NoteItemType.text]
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

/// Defines the different types of items that can be included in a note
///
/// Available types:
/// * [title] - A title or heading
/// * [text] - Regular text content
/// * [checkbox] - A checkable item
/// * [link] - A hyperlink
/// * [image] - An image
/// * [video] - A video
/// * [audio] - An audio file
enum NoteItemType {
  title,
  text,
  checkbox,
  link,
  image,
  video,
  audio,
}

/// Defines the available font styles for note content
///
/// Available styles:
/// * [sans] - Sans-serif font
/// * [serif] - Serif font
/// * [monospace] - Monospace font
enum NoteFontStyle {
  sans,
  serif,
  monospace,
}
