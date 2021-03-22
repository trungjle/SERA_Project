import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/providers/entry_provider.dart';
import 'package:sera_app/screens/record.dart';
import 'package:sera_app/utils/constants.dart';

class EntryScreen extends StatefulWidget {
  final Entry entry;

  EntryScreen({required this.entry});

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final entryProvider = Provider.of<EntryProvider>(context, listen: false);
    entryProvider.loadAll(widget.entry);
    if (widget.entry.entryId != '') {
      contentController.text = widget.entry.content;
      titleController.text = widget.entry.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(formatDate(entryProvider.date, [MM, ' ', d, ' ', yyyy])),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _pickDate(context, entryProvider).then((value) {
                  entryProvider.changeDate = value;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.record_voice_over),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecordSpeech(
                          entry: widget.entry,
                        )));
              },
            ),
            (widget.entry.entryId != '')
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      entryProvider.deleteEntry(widget.entry.entryId);
                      Navigator.of(context).pop();
                    },
                  )
                : Container(),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 20.0, bottom: 5.0),
              child: TextField(
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                    hintText: 'Enter Title', border: InputBorder.none),
                onChanged: (String value) => entryProvider.changeTitle = value,
                controller: titleController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 30.0, top: 10.0, bottom: 5.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Entry details',
                    border: InputBorder.none,
                  ),
                  style: createContent,
                  maxLines: null,
                  onChanged: (String value) =>
                      entryProvider.changeEntry = value,
                  controller: contentController,
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          entryProvider.saveEntry();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<DateTime> _pickDate(
      BuildContext context, EntryProvider entryProvider) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: entryProvider.date,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null) {
      return picked;
    } else {
      return entryProvider.date;
    }
  }
}
