import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constants.dart';

Widget buildNoticeItem(
    BuildContext context, DocumentSnapshot documentSnapshot) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: kPrimaryColor.withOpacity(0.6),
            width: 0.7,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostHeader(documentSnapshot, context),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            height: 0.5,
          ),
          documentSnapshot.data()['mediaUrl'].isNotEmpty
              ? buildPostImage(documentSnapshot)
              : Container(
                  height: 0,
                  width: 0,
                ),
          buildNotice(documentSnapshot),
        ],
      ),
    ),
  );
}

Widget buildPostHeader(
    DocumentSnapshot documentSnapshot, BuildContext context) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notice by ',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              documentSnapshot.data()['from'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            )
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Text(
          timeago.format(documentSnapshot.data()['timestamp'].toDate()),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
  );
}

Widget buildPostImage(DocumentSnapshot documentSnapshot) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: documentSnapshot.data()['mediaUrl'],
        placeholder: (context, url) {
          return Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          );
        },
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildNotice(DocumentSnapshot documentSnapshot) {
  return Container(
    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
    child: Text(
      documentSnapshot.data()['notice'],
      style: TextStyle(
        fontSize: 16.0,
      ),
    ),
  );
}
