
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_lorry/manager/reporting/Reports.dart';
import 'package:e_lorry/manager/reporting/pdfView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';

ptReportView(context) async {

  final Document pdf = Document();

  List<List<String>> serve = new List();
  serve.add(<String>['TRUCK', 'ENGINE','ELECTRONICS','BRAKES','FRONT SUSPENSION', 'REAR SUSPENSION', 'CABIN', 'BODY', 'TYRES', 'DATES', 'OTHER'],);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userCompany = prefs.getString('company');
  final QuerySnapshot result =
  await Firestore.instance.collection("posttrip").where('company', isEqualTo: userCompany).getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  // My list I want to create.

  documents.forEach((snapshot) {
    List<String> recind = <String>[
      snapshot.data['Truck'],
      snapshot.data['Engine'].toString(),
      snapshot.data['Electronics'].toString(),
      snapshot.data['Brakes'].toString(),
      snapshot.data['Front suspension'].toString(),
      snapshot.data['Rear suspension'].toString(),
      snapshot.data['Cabin'].toString(),
      snapshot.data['Body'].toString(),
      snapshot.data['Wheel Details'].toString(),
      snapshot.data['Dates'].toString(),
      snapshot.data['Other'].toString(),
    ];
    serve.add(recind);
  });



  pdf.addPage(MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat(40 * PdfPageFormat.cm, 50.0 * PdfPageFormat.cm, marginTop: 2 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Elorry Report',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 0.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Header(
            level: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Post Trip Report - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', textScaleFactor: 2),
                ])),
        Padding(padding: const EdgeInsets.all(10)),
        Table.fromTextArray(context: context, data: serve),
      ]));

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());


  return file;
}