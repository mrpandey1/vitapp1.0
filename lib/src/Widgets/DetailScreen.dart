import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitapp/src/constants.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

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
  Uint8List bytes;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildImage(
                        widget.type == 'image' ? widget.mediaUrl : kPdfImage),
                  ),
                  widget.type == 'pdf'
                      ? buildPDFFooter(context)
                      : buildNoticeFooter(context, widget.mediaUrl),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: showText(widget.notice),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoticeFooter(BuildContext context, values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () => downloadPost(values),
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => _onShare(),
        ),
      ],
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

  Widget buildPDFFooter(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(widget.documentSnapshot.data()['fileName']),
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
            IconButton(
              onPressed: () => _onShare(),
              icon: Icon(
                Icons.share,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
        Divider(),
      ],
    );
  }

  static Future<bool> _checkAndGetPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      final Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    return true;
  }

  Future<Null> _onShare() async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(widget.mediaUrl));
      var response = await request.close();
      bytes = await consolidateHttpClientResponseBytes(response);
      if (bytes.length != null) {
        data1(bytes);
      }
    } catch (e) {
      print(e);
    }
  }

  data1(bytes) async {
    String value;
    String name;
    if (widget.type == 'image') {
      value = 'image/jpg';
      name = '${widget.documentSnapshot.data()['fileName']}.jpg';
    } else if (widget.type == 'pdf') {
      value = 'application/pdf';
      name = '${widget.documentSnapshot.data()['fileName']}.pdf';
    }
    await Share.file('gaurang', name, bytes, value, text: widget.notice);
  }

  Widget _downloadPost(values) {
    return FlatButton(
      onPressed: () async {
        downloadPost(values);
      },
      child: Text('Download Image'),
    );
  }

  downloadPost(values) async {
    if (await _checkAndGetPermission() != null) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd-HH-mm-ss');
      final String formatted = formatter.format(now);
      String appdirectory = '/storage/emulated/0/Download/';
      final Directory directory =
          await Directory(appdirectory + '/VITAPP').create(recursive: true);
      String dir = directory.path;
      final String localfile = 'img-' + formatted + '.jpg';
      final String url = values;
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          savedDir: dir,
          fileName: localfile,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
      } on PlatformException catch (e) {
        print(e);
      }
      return "success";
    }
  }
}
