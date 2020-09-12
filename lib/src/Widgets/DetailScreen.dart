import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

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

    return Center(
      child: Linkify(
        onOpen: _onOpen,
        text: notice,
      ),
    );
  }

  Widget buildImage(image) {
    return PinchZoomImage(
      image: CachedNetworkImage(
        imageUrl: image,
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
}
