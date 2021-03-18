import 'package:flutter/foundation.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class EntryProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  DateTime _date;
  String _content;
  String _title;
  String _entryId;
  var uuid = Uuid();

  //Getters
  DateTime get date => _date;
  String get content => _content;
  String get title => _title;
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

  //Functions

  loadAll(Entry entry) {
    if (entry != null) {
      _date = DateTime.parse(entry.date);
      _content = entry.content;
      _title = entry.title;
      _entryId = entry.entryId;
    } else {
      _date = DateTime.now();
      _title = null;
      _content = null;
      _entryId = null;
    }
  }

  saveEntry() {
    if (_entryId == null) {
      //Add
      var newEntry = Entry(
          date: _date.toIso8601String(),
          title: _title,
          content: _content,
          entryId: uuid.v1());
      firestoreService.setEntry(newEntry);
    } else {
      var updatedEntry = Entry(
          date: _date.toIso8601String(),
          title: _title,
          content: _content,
          entryId: _entryId);
      firestoreService.setEntry(updatedEntry);
    }
  }

  deleteEntry(String entryId) {
    firestoreService.deleteEntry(entryId);
  }
}
