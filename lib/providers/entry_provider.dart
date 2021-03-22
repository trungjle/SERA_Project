import 'package:flutter/foundation.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class EntryProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  late DateTime _date;
  late String _content;
  late String _title;
  late String _entryId;
  late String _emotion;
  var uuid = Uuid();

  //Getters
  DateTime get date => _date;
  String get content => _content;
  String get title => _title;
  String get emotion => _emotion;
  Stream<List<Entry>> get entries => firestoreService.getEntries();

  //Setters

  set changeDate(DateTime date) {
    _date = date;
    //tells the UI to refresh
    notifyListeners();
  }

  set changeEntry(String content) {
    _content = content;
    notifyListeners();
  }

  set changeTitle(String title) {
    _title = title;
    notifyListeners();
  }

  set changeEmotion(String emotion) {
    _emotion = emotion;
    notifyListeners();
  }

  //Functions

  loadAll(Entry entry) {
    _date = DateTime.parse(entry.date);
    _content = entry.content;
    _title = entry.title;
    _emotion = entry.emotion;
    _entryId = entry.entryId;
  }

  saveEntry() {
    if (_entryId == '') {
      //Add
      var newEntry = Entry(
          date: _date.toIso8601String(),
          title: _title,
          content: _content,
          emotion: _emotion,
          entryId: uuid.v1());
      firestoreService.setEntry(newEntry);
    } else {
      var updatedEntry = Entry(
          date: _date.toIso8601String(),
          title: _title,
          content: _content,
          entryId: _entryId,
          emotion: _emotion);
      firestoreService.setEntry(updatedEntry);
    }
  }

  deleteEntry(String entryId) {
    firestoreService.deleteEntry(entryId);
  }
}
