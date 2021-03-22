class Entry {
  final String entryId;
  late final String date;
  final String content;
  final String title;
  final String emotion;

  Entry(
      {required this.date,
      required this.title,
      required this.emotion,
      required this.content,
      required this.entryId});

  factory Entry.fromJSON(Map<String, dynamic> json) {
    return Entry(
        date: json['date'],
        title: json['title'],
        content: json['content'],
        emotion: json['emotion'],
        entryId: json['entryId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'content': content,
      'emotion': emotion,
      'entryId': entryId
    };
  }
}
