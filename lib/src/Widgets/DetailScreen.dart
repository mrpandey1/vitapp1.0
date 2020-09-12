import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:vitapp/src/constants.dart';

class DetailScreen extends StatefulWidget {
  final String mediaUrl, from, notice, type;
  final DateTime timestamp;
  final DocumentSnapshot documentSnapshot;
  DetailScreen(
      {this.mediaUrl,
      this.from,
      this.notice,
      this.timestamp,
      this.type,
      this.documentSnapshot});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.from,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              timeago.format(widget.timestamp),
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: buildImage(
                widget.type == 'image' ? widget.mediaUrl : kPdfImage),
          ),
          widget.type == 'pdf' ? buildPDFFooter(context) : Container(),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
            child: showText(widget.notice),
          ),
        ],
      ),
    );
  }

  Widget showText(notice) {
    Future<void> _onOpen(LinkableElement link) async {
      if (await canLaunch(link.url)) {
        await launch(link.url);
      } else {
        throw 'Could not launch $link';
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Linkify(
            onOpen: _onOpen,
            text: notice,
            linkStyle: TextStyle(
              color: kPrimaryColor,
            ),
            style: TextStyle(
              height: 1.5,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(image) {
    return PinchZoomImage(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: image,
            height: widget.type == 'pdf' ? 150 : null,
          ),
        ),
      ),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
    );
  }

  Widget buildImage2(image) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
        setState(() {});
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        _scale = _previousScale * details.scale;
        setState(() {});
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = 1.0;
        setState(() {});
      },
      child: RotatedBox(
        quarterTurns: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
            child: CachedNetworkImage(imageUrl: image),
          ),
        ),
      ),
    );
  }

  Widget buildPDFFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () => {openPdf(context, widget.documentSnapshot)},
                icon: Icon(
                  Icons.remove_red_eye,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                onPressed: () => {downloadPdf(widget.documentSnapshot)},
                icon: Icon(
                  Icons.file_download,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
