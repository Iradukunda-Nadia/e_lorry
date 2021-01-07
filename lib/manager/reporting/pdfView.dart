import 'dart:io';

import 'package:e_lorry/manager/reporting/fuelReport.dart';
import 'package:e_lorry/manager/reporting/ptReport.dart';
import 'package:e_lorry/manager/reporting/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:printing/printing.dart';

class PdfViewerPage extends StatefulWidget {
  String formType;
  PdfViewerPage({this.formType,});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }


  loadDocument() async {
    File file = widget.formType == 'fuel'? await fuelReportView(context): widget.formType == 'parts'? await reportView(context):widget.formType == 'ptrip'? await ptReportView(context): await reportView(context);

    document = await PDFDocument.fromFile(file);

    setState(() => _isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document, showPicker: false,)),
    );
  }
}
