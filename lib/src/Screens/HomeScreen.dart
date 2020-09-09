import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vitapp/src/Screens/AddNotes.dart';
import 'package:vitapp/src/Screens/AddNotices.dart';
import 'TimeLine.dart';
import 'Authenticator.dart';
import 'package:vitapp/src//Widgets/Animation.dart';
import 'package:vitapp/src//Widgets/header.dart';
import 'package:vitapp/src/constants.dart';

final postRef = FirebaseFirestore.instance.collection('posts');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final StorageReference storageRef = FirebaseStorage.instance.ref();
final notesRef = FirebaseFirestore.instance.collection('notes');
final subjectsRef = FirebaseFirestore.instance.collection('subjects');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true, isCenterTitle: true),
      body: TimeLine(),
      drawer: Drawer(
          child: FirebaseAuth.instance.currentUser != null
              ? buildAdminSideBar()
              : buildStudentSideBar()),
    );
  }

  ListView buildStudentSideBar() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Text(
              'Student Header',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
        ),
        getTile(Icons.filter_frames, 'Notice',
            function: () => {Navigator.pop(context)}),
        Divider(),
        getTile(Icons.library_books, 'Notes'),
        Divider(),
        getTile(Icons.account_circle, 'Admin Login', function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Authenticator()));
        }),
        Divider(),
      ],
    );
  }

  ListView buildAdminSideBar() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
            child: Text(
              'Admin Header',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
          ),
        ),
        getTile(Icons.filter_frames, 'Add Notice',
            function: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNotice()),
                  )
                }),
        Divider(),
        getTile(Icons.library_books, 'Add Notes',
            function: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNotes()),
                  )
                }),
        Divider(),
        getTile(Icons.exit_to_app, 'Sign Out', function: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }),
      ],
    );
  }

  GestureDetector getTile(IconData icon, String text, {Function function}) {
    return GestureDetector(
      onTap: function,
      child: ListTile(
        leading: Icon(
          icon,
          color: kPrimaryColor,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
