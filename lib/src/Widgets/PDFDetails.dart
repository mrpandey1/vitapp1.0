import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitapp/src/Screens/PDFViewer.dart';
import 'package:vitapp/src/constants.dart';

class PDFDetailScreen extends StatefulWidget {
  final String mediaUrl, from, notice, filename;
  PDFDetailScreen({this.mediaUrl, this.from, this.notice, this.filename});
  @override
  _PDFDetailScreenState createState() => _PDFDetailScreenState();
}

class _PDFDetailScreenState extends State<PDFDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.from),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [buildNoticeItem(widget.mediaUrl), showText(widget.notice)],
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

  Widget buildNoticeItem(pdf) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          openPdf(context, pdf);
        },
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
              Divider(
                color: Colors.grey.withOpacity(0.5),
                height: 0.5,
              ),
              buildImage(),
              buildPDFFooter(widget.filename, pdf)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPDFFooter(filename, pdf) {
    return Column(
      children: [
        Divider(),
        ListTile(
          title: Text(
            filename,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: () => {downloadPdf(pdf)},
            icon: Icon(
              Icons.file_download,
              color: kPrimaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget buildImage() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Center(
            child: CachedNetworkImage(
              height: 110.0,
              imageUrl: kPdfImage,
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
        ),
      ),
    );
  }

  downloadPdf(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openPdf(context, url) async {
    PDFDocument doc = await PDFDocument.fromURL(url);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewer(
          document: doc,
        ),
      ),
    );
  }
}
