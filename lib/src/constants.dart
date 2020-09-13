import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitapp/src/Screens/PDFViewer.dart';

const kPrimaryColor = Color(0xff393185);

//const kPdfImage =
//    'https://is1-ssl.mzstatic.com/image/thumb/Purple124/v4/a4/1f/86/a41f8664-0752-d8fd-b0ca-14108bda3505/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png';
const kPdfImage =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/PDF_file_icon.svg/1200px-PDF_file_icon.svg.png';

openPdf(BuildContext context, DocumentSnapshot documentSnapshot) async {
  PDFDocument doc =
      await PDFDocument.fromURL(documentSnapshot.data()['mediaUrl']);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewer(
        document: doc,
      ),
    ),
  );
}

downloadPdf(DocumentSnapshot documentSnapshot) async {
  String url = documentSnapshot.data()['mediaUrl'];
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
