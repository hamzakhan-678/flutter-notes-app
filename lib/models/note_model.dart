class NoteModel {
  final int? id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isPinned': isPinned ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isPinned: map['isPinned'] == 1 ? true : false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
