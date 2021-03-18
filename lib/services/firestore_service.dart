import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sera_app/models/entry.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Entry>> getEntries() {
    return _db.collection('entries').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Entry.fromJSON(doc.data())).toList());
  }

  //Add/Update(Upsert)
  Future<void> setEntry(Entry entry) {
    //update the entries with the option to omit certain entry fields if unrequired
    var options = SetOptions(merge: true);
    return _db
        .collection('entries')
        .doc(entry.entryId)
        .set(entry.toMap(), options);
  }

  Future<void> deleteEntry(String entryId) {
    return _db.collection('entries').doc(entryId).delete();
  }
}
