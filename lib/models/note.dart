// lib/models/note.dart
class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isFavorite;        // ← MỚI: yêu thích
  String color;           // ← MỚI: màu (hex string)

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.color = '0xFFFFFFFF', // trắng mặc định
  });

  factory Note.fromMap(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      isFavorite: data['isFavorite'] ?? false,
      color: data['color'] ?? '0xFFFFFFFF',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String() ?? createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'color': color,
    };
  }
}