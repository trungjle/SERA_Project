class Entry {
  final String entryId;
  final String date;
  final String content;
  final String title;

  Entry(
      {required this.date,
      required this.title,
      required this.content,
      required this.entryId});

  factory Entry.fromJSON(Map<String, dynamic> json) {
    return Entry(
        date: json['date'],
        title: json['title'],
        content: json['content'],
        entryId: json['entryId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'content': content,
      'entryId': entryId
    };
  }
}
