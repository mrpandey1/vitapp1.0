import 'package:flutter/material.dart';
import 'package:vitapp/Screens/AddNotices.dart';
import 'package:vitapp/Screens/TimeLine.dart';
import 'package:vitapp/Widgets/Animation.dart';
import 'package:vitapp/Widgets/header.dart';
import 'package:vitapp/constants.dart';

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Yo'),
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
            ),
            ListTile(
                title: Text('Add Notice'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, BouncyPageRoute(widget: AddNotice()));
                }),
          ],
        ),
      ),
    );
  }
}
