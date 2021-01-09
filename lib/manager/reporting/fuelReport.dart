
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

fuelReportView(context) async {

  final Document pdf = Document();

  List<List<String>> serve = new List();
  serve.add(<String>['TRUCK', 'CURR LTRS','REQUESTED FUEL','PER LTR', 'TOTAL (KSH.)', 'FUEL STATION', 'TILL', 'RECEPIENT', 'REQUESTED BY', 'STATUS', 'NEW READING'],);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userCompany = prefs.getString('company');
  final QuerySnapshot result =
  await Firestore.instance.collection("fuelRequest").where('company', isEqualTo: userCompany).where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now())).orderBy('timestamp', descending: true).getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  // My list I want to create.

  documents.forEach((snapshot) {
    List<String> recind = <String>[
      snapshot.data['Truck'],
      snapshot.data['Current litres'],
      snapshot.data['Requested fuel'],
      snapshot.data['Price per liter'],
      snapshot.data['Total'],
      snapshot.data['FuelStaion'],
      snapshot.data['Till'],
      snapshot.data['Receipent'],
      snapshot.data['reqby'],
      snapshot.data['status'],
      snapshot.data['New Fuel reading'],
    ];
    serve.add(recind);
  });



  pdf.addPage(MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat(29.7 * PdfPageFormat.cm, 45.0 * PdfPageFormat.cm, marginAll: 2 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('FUEL REQUEST - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}', textScaleFactor: 2),
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