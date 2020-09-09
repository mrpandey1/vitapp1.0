import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vitapp/Widgets/NoticeItem.dart';
import 'HomeScreen.dart';

List<DocumentSnapshot> _list;

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildTimeline();
  }

  Widget buildTimeline() {
    List<DocumentSnapshot> _list;
    return StreamBuilder(
        stream: timelineRef
            .doc('all')
            .collection('timelinePost')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Text('hey');
                });
          }
          _list = snapshots.data.docs;
          print(_list.length);
          return _list.length == 0
              ? Center(
                  child: Text('No Notice For Now!'),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    return buildNoticeItem(context, _list[index]);
                  },
                );
        });
  }
}
