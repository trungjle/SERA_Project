import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { share, delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDimissed;

  const SlidableWidget({
    @required this.child,
    Key key,
    this.onDimissed,
  }) : super(key: key);

  Widget build(BuildContext context) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: child,
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Share',
              color: Colors.indigo,
              icon: Icons.share,
              onTap: () => onDimissed(SlidableAction.share),
            ),
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => onDimissed(SlidableAction.delete))
          ]);
}
