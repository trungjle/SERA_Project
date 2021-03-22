import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sera_app/models/entry.dart';
import 'package:sera_app/screens/entry.dart';
import 'package:sera_app/utils/constants.dart';

class EntryListTile extends StatelessWidget {
  const EntryListTile({
    required Key key,
    required this.context,
    required this.item,
  }) : super(key: key);

  final BuildContext context;
  final Entry item;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              tileMode: TileMode.clamp,
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 0.2),
              colors: [Color(0x1AFFFFFF), Color(0x4DFFFFFF), Colors.white]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text(
            item.title,
            style: listTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            formatDate(DateTime.parse(item.date), [MM, ' ', d, ' ', yyyy]),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EntryScreen(entry: item)));
          },
        ));
  }
}
