import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/providers/entry_provider.dart';
import 'package:sera_app/screens/entry.dart';
import 'package:sera_app/widgets/Entry_ListTile.dart';
import 'package:sera_app/widgets/slidable_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var entryProvider = Provider.of<EntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sera Says'),
      ),
      body: StreamBuilder<List<Entry>>(
          stream: entryProvider.entries,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 0.2),
                          colors: [
                            Color(0x1AFFFFFF),
                            Color(0x4DFFFFFF),
                            Colors.white
                          ]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: (SlidableWidget(
                      child: EntryListTile(item: item, context: context),
                      onDimissed: (action) =>
                          dismissSlidableItem(item, action, entryProvider),
                    )),
                  );
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EntryScreen()));
        },
      ),
    );
  }

  void dismissSlidableItem(
      Entry entry, SlidableAction action, EntryProvider entryProvider) {
    switch (action) {
      case SlidableAction.share:
        break;
      case SlidableAction.delete:
        entryProvider.deleteEntry(entry.entryId);
    }
  }
}
