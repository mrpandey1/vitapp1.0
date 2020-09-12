import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:vitapp/src/constants.dart';

class DetailScreen extends StatefulWidget {
  final String mediaUrl, from, notice;
  DetailScreen({this.mediaUrl, this.from, this.notice});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.from),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [buildImage(widget.mediaUrl), showText(widget.notice)],
        ),
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

    return notice.toString().trim() != ''
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Linkify(
                      style: TextStyle(fontSize: 18),
                      onOpen: _onOpen,
                      text: notice,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 0,
          );
  }

  Widget buildImage(image) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PinchZoomImage(
        image: CachedNetworkImage(
          imageUrl: image,
        ),
        zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        hideStatusBarWhileZooming: true,
      ),
    );
  }
}
