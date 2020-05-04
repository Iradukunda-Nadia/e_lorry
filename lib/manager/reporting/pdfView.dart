import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);


  loadDocument() async {
    PDFDocument document;
    document = await PDFDocument.fromAsset('assets/sample.pdf');
  }

  @override
  Widget build(BuildContext context) {
    Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
          ),
    );
  }
}